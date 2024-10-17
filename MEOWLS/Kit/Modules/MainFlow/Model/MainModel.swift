//
//  MainModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import UIKit
import Combine

enum MainModel {}

extension MainModel {

    struct InputModel {}

    struct InitialModel {
        let inputModel: InputModel
        let router: MainRouterProtocol
        let apiService: MainApiServiceProtocol
        let favoritesService: FavoritesServiceProtocol
    }

    typealias Section = ItemsDataSource<MainModel.Row>.Section<MainModel.Row>

    enum Row: Item {
        case header(DomainHeaderWithButtonCell.ViewModel)
        case slider(SliderModel)
        case productsSlider(SliderModel)
        case tagsSlider(SliderModel)
        case verticalBanners(VerticalModel)

        struct SliderModel {
            let cellModel: BannerHorizontalCollectionCell.ViewModel
            let bannerID: String
        }

        struct VerticalModel {
            let cellModel: BannerVerticalCollectionCell.ViewModel
            let bannerID: String
        }
    }

    enum Route {
        case search
        case product(_ product: Product)
        case productsSet(_ query: String, _ title: String)
        case category(_ category: Category)
        case webView(URL)
        case sale(_ sale: Sale)
        case pushSubscriptionDialog
    }

    enum LoadingStatus {
        case startLoading, stopLoading
    }

    enum DeeplinkHandle {
        case banner(slug: String)
    }

}

extension MainModel {

    struct BindingInput {
        let viewAction: PassthroughSubject<ViewAction, Never>
    }

    struct BindingOutput {
        let label: AnyPublisher<Label?, Never>
        let viewState: AnyPublisher<ViewState, Never>
    }

    enum Label {
        case showError(String?)
    }

    enum ViewState {
        case initial(DomainSearchBar.ViewModel?)
        case loading(LoadingStatus)
        case fillingDataState(FillingDataState)

        struct FillingDataState {
            let items: [Section]
        }
    }

    enum ViewAction {
        case viewDidLoad(_ size: CGSize)
        case triggerRefresh
        case deeplinkInput
        case close
    }

}

extension MainModel {

    enum Constants {

        static let commonInsets = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        
        private static let horizontalInset: CGFloat = 16.0

        enum DomainHeader {
            static let inset = UIEdgeInsets(top: 16.0, left: horizontalInset, bottom: 12.0, right: horizontalInset)
            static let height: CGFloat = 36.0
        }

        enum Slider {
            static let spacing: CGFloat = 12.0
            /// To calculate the banner size relative to the screen
            static let itemInset = UIEdgeInsets(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)
            // width / height
            static let itemRatio: CGFloat = 319.0 / 390.0

            static func inset(for spacings: MainBanner.UISettings.Spacing?) -> UIEdgeInsets {
                guard let spacings else {
                    return commonInsets
                }
                return UIEdgeInsets(top: CGFloat(spacings.top),
                                    left: horizontalInset,
                                    bottom: CGFloat(spacings.bottom),
                                    right: horizontalInset)
            }
        }

        enum ProductsSlider {
            static let itemWidth: CGFloat = 180.0
            static let itemHeight: CGFloat = 297.0
        }

        enum SmallSlider {
            static let insets = UIEdgeInsets(top: 24.0, left: horizontalInset, bottom: 0.0, right: horizontalInset)
            static let spacing: CGFloat = 8.0
        }

        enum VerticalBanners {
            static let horizontalSpacing: CGFloat = 12.0
            static let verticalSpacing: CGFloat = 12.0
            // width / height
            static let multipleItemsRatio: CGFloat = 343.0 / 177.0
            static let singleItemRatio: CGFloat = 343.0 / 200.0
        }

        enum Tags {
            static let spacing: CGFloat = 8.0
            static let estimatedItemWidth: CGFloat = 100.0
            static let itemHeight: CGFloat = 48.0
            static let imageWidth: CGFloat = 24.0

            static func inset(for spacings: MainBanner.UISettings.Spacing?) -> UIEdgeInsets {
                guard let spacings else {
                    return commonInsets
                }
                return UIEdgeInsets(top: CGFloat(spacings.top),
                                    left: horizontalInset,
                                    bottom: CGFloat(spacings.bottom),
                                    right: horizontalInset)
            }
        }

    }

}
