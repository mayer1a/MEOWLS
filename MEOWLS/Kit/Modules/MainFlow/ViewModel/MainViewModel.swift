//
//  MainViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import UIKit
import Combine
import Kingfisher

final class MainViewModel: MainViewModelProtocol {

    @Published private var viewState: Model.ViewState = .initial(nil)
    @Published private var label: Model.Label? = nil

    var viewStatePublisher: Published<Model.ViewState>.Publisher { $viewState }
    var labelPublisher: Published<Model.Label?>.Publisher { $label }

    private var sidersSizes: [String: CGSize] = [:]
    private var contentSize = UIScreen.main.bounds.size

    private var banners: [MainBanner] = []

    private let downloadGroup = DispatchGroup()
    private let router: MainRouterProtocol
    private let apiService: MainApiServiceProtocol
    private let favoriteService: FavoritesServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    init(with model: Model.InitialModel) {
        self.router = model.router
        self.apiService = model.apiService
        self.favoriteService = model.favoritesService

        self.setupInitialSearchBarState()
    }

}

extension MainViewModel {

    func binding(input: Model.BindingInput) -> Model.BindingOutput {
        input.viewAction
            .sink { [weak self] action in
                self?.execute(action: action)
            }
            .store(in: &cancellables)

        return .init(label: labelPublisher.eraseToAnyPublisher(), viewState: viewStatePublisher.eraseToAnyPublisher())
    }

    private func execute(action: Model.ViewAction) {
        switch action {
        case .viewDidLoad(let contentSize):
            self.contentSize = contentSize
            loadData()

        case .triggerRefresh:
            loadData()

        case .deeplinkInput:
            break

        case .close:
            router.close()

        }
    }

}

private extension MainViewModel {

    func loadingState(_ status: Model.LoadingStatus) {
        viewState = .loading(status)
    }

    func fillingDataState() {
        let sections = createSections()
        viewState = .fillingDataState(.init(items: sections))
    }

    func setupInitialSearchBarState() {
        let tapHandler: VoidClosure? = { [weak self] in
            self?.router.open(.search)
        }

        viewState = .initial(.init(placeHolder: Strings.Main.search, state: .initial(.init(tapHandler: tapHandler))))
    }

}

private extension MainViewModel {

    func createSections() -> [Model.Section] {
        var section = Model.Section()

        banners.forEach { banner in
            let isKnownType = banner.placeType != .undefined
            if let headerRow = MainSectionsBuilder.buildHeader(banner, completion: navigateWith), isKnownType {
                section.append(headerRow)
            }

            switch banner.placeType {
            case .bannersHorizontal:
                let sliderRow = MainSectionsBuilder.buildSlider(banner,
                                                                imageSize: sidersSizes[banner.id],
                                                                size: contentSize,
                                                                completion: navigateWith)
                section.append(sliderRow)

            case .productsCollection:
                let sliderRow = MainSectionsBuilder.buildProductsSlider(banner,
                                                                        favoritesService: favoriteService,
                                                                        completion: navigateWith)
                if let sliderRow {
                    section.append(sliderRow)
                }

            case .bannersVertical, .singleBanner:
                let verticalRow = MainSectionsBuilder.buildVertical(banner, size: contentSize, completion: navigateWith)

                section.append(verticalRow)

            case .categories:
                let tags = MainSectionsBuilder.buildTags(banner, completion: navigateWith)
                section.append(tags)

            default:
                break

            }
        }

        return [section]
    }


}

private extension MainViewModel {

    func showProduct(product: Product) {
        router.open(.product(product))
    }

    func navigateWith(type: MainBanner.PlaceType?, redirect: Redirect?, value: Any?) {
        guard redirect != nil || value != nil else {
            return
        }

        switch type {
        case .categories where value is Category:
            router.open(.category(value as! Category))

        case .productsCollection where value is Product:
            router.open(.product(value as! Product))

        case .bannersHorizontal, .bannersVertical, .singleBanner:
            handleRedirect(redirect)

        default:
            break

        }
    }

    func handleRedirect(_ redirect: Redirect?) {
        guard let redirect else {
            return
        }

        switch redirect.redirectType {
        case .object:
            handleObjectRedirect(redirect)

        case .productsCollection:
            handleProductsCollectionRedirect(redirect)

        }
    }

    func handleObjectRedirect(_ redirect: Redirect) {
        switch redirect.objectType {
        case .product:
            break

        case .sale where redirect.objectID != nil:
            loadSale(with: redirect.objectID!) { [weak self] sale in
                self?.router.open(.sale(sale))
            }

        case .sale where redirect.url != nil:
            guard let url = redirect.url?.toURL else {
                return
            }
            router.open(.webView(url))

        default:
            break

        }
    }

    func handleProductsCollectionRedirect(_ redirect: Redirect) {
        guard let productsSet = redirect.productsSet else {
            return
        }

        if let query = productsSet.query {
            router.open(.productsSet(query, productsSet.name))
        } else if let category = productsSet.category {
            router.open(.category(category))
        }
    }

}

private extension MainViewModel {

    func askPushNotifications() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate

        #if Store
        let waitSeconds: Int = 0
        #else
        let waitSeconds = 2678400
        #endif

        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .notDetermined {
                self?.presentPushSubscriptionDialog()
            }
        }
    }

    private func presentPushSubscriptionDialog() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.router.open(.pushSubscriptionDialog)
        }
    }

}

private extension MainViewModel {

    func loadData() {
        loadingState(.startLoading)

        apiService.loadBanners { [weak self] response in
            guard let self else {
                return
            }

            if let banners = response.data {
                self.banners = banners
                self.getFirstAutomaticSlidersImage()
                self.downloadGroup.notify(queue: .main) { [weak self] in
                    if let self {
                        self.loadingState(.stopLoading)
                        self.fillingDataState()
                    }
                }
            } else {
                self.label = .showError(response.error)
                self.loadingState(.stopLoading)
            }
        }
    }

    private func loadSale(with id: String, handler: @escaping (Sale) -> Void) {
        loadingState(.startLoading)

        apiService.loadSale(id: id) { [weak self] response in
            guard let self else {
                return
            }

            self.loadingState(.stopLoading)

            if let promotion = response.data {
                handler(promotion)
            } else {
                self.label = .showError(Strings.Main.promotionDoesntExist)
            }
        }
    }

    func getFirstAutomaticSlidersImage() {
        let automaticSliders = banners.filter({ $0.placeType == .bannersHorizontal })
        getFisrtBannerImage(automaticSliders)
    }

    func getFisrtBannerImage(_ banners: [MainBanner]) {
        banners.enumerated().forEach { index, banner in
            guard
                let imageURL = banner.banners?.first(where: { $0.image?.smallest != nil })?.image?.smallest?.toURL
            else {
                return
            }

            downloadGroup.enter()

            getImageSize(from: imageURL) { [weak self] size in
                guard let self else {
                    return
                }

                self.sidersSizes[banner.id] = size
                self.downloadGroup.leave()
            }
        }
    }

    func getImageSize(from url: URL, completion: ((CGSize?) -> Void)?) {
        KingfisherManager.shared.retrieveImage(with: url) { result in
            switch result {
            case .success(let value):
                completion?(value.image.size)

            case .failure:
                completion?(nil)

            }
        }
    }

}
