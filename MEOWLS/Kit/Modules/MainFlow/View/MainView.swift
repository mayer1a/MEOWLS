//
//  MainView.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import UIKit
import Combine
import SnapKit

final class MainViewController: NiblessViewController {

    private var viewModel: MainViewModelProtocol
    private let viewAction = PassthroughSubject<MainModel.ViewAction, Never>()
    private var rowSource: ItemsDataSource<MainModel.Row> = .init()
    private var lastBannersIDs = [String]()
    private var cancellables: Set<AnyCancellable> = []

    required init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        binding()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private lazy var searchBar = DomainSearchBar()
    private lazy var loader = LoaderWrapper()
    private lazy var refreshControl = RefreshControllWrapper()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        table.showsVerticalScrollIndicator = false
        table.register(cell: DomainHeaderWithButtonCell.self)
        table.showsVerticalScrollIndicator = false

        return table
    }()

    @objc private func onRefresh() {
        viewAction.send(.triggerRefresh)
        refreshControl.endRefreshingControl(resetOffset: false)
    }

}

private extension MainViewController {

    func setupUI() {
        refreshControl.configureRefreshControl(tableView: tableView, target: self, action: #selector(onRefresh))
        view.backgroundColor = UIColor(resource: .backgroundWhite)

        setupConstraints()
    }

    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

private extension MainViewController {

    func binding() {
        let input = MainModel.BindingInput(viewAction: viewAction)
        let output = viewModel.binding(input: input)

        output.viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] viewState in
                self?.updateState(viewState)
            }
            .store(in: &cancellables)

        output.label
            .receive(on: DispatchQueue.main)
            .sink { [weak self] label in
                self?.makeLabel(label)
            }
            .store(in: &cancellables)

        viewAction.send(.viewDidLoad(view.bounds.size))
    }

}

private extension MainViewController {

    func updateState(_ state: MainModel.ViewState) {
        switch state {
        case .initial(let model):
            if let searchBarConfigureModel = model {
                searchBar.configure(with: searchBarConfigureModel)
            }

        case .loading(let state):
            switch state {
            case .startLoading:
                loader.showLoadingOnCenter(inView: tableView)
                tableView.isUserInteractionEnabled = false

            case .stopLoading:
                loader.hideLoading()
                tableView.isUserInteractionEnabled = true

            }

        case .fillingDataState(let data):
            registerUnreuseCells(sections: data.items)
            rowSource.sections = data.items
            tableView.reloadData()

        }
    }

    func makeLabel(_ label: MainModel.Label?) {
        switch label {
        case .showError(let message):
            showNetworkError(title: Strings.Common.FailedRequestView.title,
                             message: message,
                             repeatTitle: Strings.Common.FailedRequestView.button) { [weak self] in

                self?.viewAction.send(.triggerRefresh)
            }

        default:
            break

        }
    }

    func registerUnreuseCells(sections: [MainModel.Section]) {
        // Delete past registrations
        lastBannersIDs.forEach {
            tableView.register(Optional<UINib>.none, forCellReuseIdentifier: $0)
        }

        sections.forEach {
            $0.items.forEach {
                var id: String?

                switch $0 {
                case .slider(let model), .productsSlider(let model), .tagsSlider(let model):
                    id = model.bannerID
                    tableView.register(cell: BannerHorizontalCollectionCell.self, with: id)

                case .verticalBanners(let model):
                    id = model.bannerID
                    tableView.register(cell: BannerVerticalCollectionCell.self, with: id)

                default:
                    break

                }

                if let id {
                    lastBannersIDs.append(id)
                }
            }
        }
    }

}

extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        rowSource.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowSource.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch rowSource.item(at: indexPath) {
        case .header(let model):
            let cell = tableView.dequeueReusable(cell: DomainHeaderWithButtonCell.self, for: indexPath)
            cell.configureWith(model)

            return cell

        case .slider(let model), .productsSlider(let model), .tagsSlider(let model):

            let cell = tableView.dequeueReusable(cell: BannerHorizontalCollectionCell.self,
                                                 with: model.bannerID,
                                                 for: indexPath)

            cell.configure(with: model.cellModel)

            return cell

        case .verticalBanners(let model):
            let cell = tableView.dequeueReusable(cell: BannerVerticalCollectionCell.self,
                                                 with: model.bannerID,
                                                 for: indexPath)

            cell.configure(with: model.cellModel)

            return cell

        default:
            return UITableViewCell()

        }
    }

}

extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch rowSource.item(at: indexPath) {
        case .header(let model):
            return model.cellHeight

        case .slider(let model), .productsSlider(let model), .tagsSlider(let model):
            return model.cellModel.collectionHeight

        case .verticalBanners(let model):
            return model.cellModel.collectionHeight

        default:
            return UITableView.automaticDimension

        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > .zero {
            searchBar.configureShadow(needDisplay: true)
        } else if scrollView.contentOffset.y <= .zero {
            searchBar.configureShadow(needDisplay: false)
        }
    }

}

// MARK: - Previews

#if DEBUG

private final class MockViewModel: MainViewModelProtocol {

    @Published private var viewState: Model.ViewState = .initial(nil)
    @Published private var label: Model.Label? = nil

    var viewStatePublisher: Published<Model.ViewState>.Publisher { $viewState }
    var labelPublisher: Published<Model.Label?>.Publisher { $label }

    private var cancellables: Set<AnyCancellable> = []

    func binding(input: Model.BindingInput) -> Model.BindingOutput {
        input.viewAction
            .sink { _ in }
            .store(in: &cancellables)

        return .init(label: labelPublisher.eraseToAnyPublisher(), viewState: viewStatePublisher.eraseToAnyPublisher())
    }

}

@available(iOS 17, *)
#Preview {
    MainViewController(viewModel: MockViewModel())
}

#endif
