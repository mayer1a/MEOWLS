//
//  RegionView.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import UIKit
import Combine
import SnapKit

final class RegionViewController: NiblessTableViewController, UISearchBarDelegate {

    private var viewModel: RegionViewModelProtocol
    private let viewAction = PassthroughSubject<RegionModel.ViewAction, Never>()
    private var cancellables: Set<AnyCancellable> = []

    private lazy var tableView = UITableView()
    private lazy var searchBarContainer = ShadowableView()
    private lazy var searchBar = UISearchBar()
    private lazy var loader = LoaderWrapper()
    private var rowSource: ItemsDataSource<RegionModel.Row> = .init()

    required init(viewModel: RegionViewModelProtocol) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        binding()
    }

    @objc private func actionClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func getUserLocation() {
        viewAction.send(.requestLocation)
    }

    @objc
    private func close() {
        viewAction.send(.close)
    }

}

private extension RegionViewController {

    func setupUI() {
        title = Strings.Region.Choose.title
        view.backgroundColor = UIColor(resource: .backgroundWhite)

        tableView.backgroundColor = UIColor(resource: .backgroundWhite)
        tableView.separatorColor = UIColor(resource: .backgroundSecondary)
        tableView.rowHeight = 56
        tableView.estimatedRowHeight = 56
        tableView.sectionHeaderHeight = 28
        tableView.sectionFooterHeight = 28
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cell: RegionCell.self)

        searchBar.searchBarStyle = .minimal
        searchBar.isTranslucent = false
        searchBar.enablesReturnKeyAutomatically = true
        searchBar.textContentType = .addressCity
        searchBar.delegate = self
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityIdentifier = "search_field"
        searchBar.placeholder = Strings.Region.Choose.search

        setupNavigationBar()
        setupConstraints()
    }

    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(searchBarContainer)

        searchBarContainer.addCustomSubview(searchBar) { make in
            make.height.equalTo(56)
            make.edges.equalToSuperview()
        }
        searchBarContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(tableView.snp.top)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    func setupNavigationBar() {
        if SettingsService.shared[.userRegion] as City? == nil {
            navigationItem.leftBarButtonItems = []
        } else {
            navigationController?.applyItems(left: .close())
        }

        navigationController?.applyItems(right: .location(target: self, #selector(getUserLocation)))
    }

}

extension RegionViewController {

    private func binding() {
        let input = RegionModel.BindingInput(viewAction: viewAction)
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

        viewAction.send(.viewDidLoad)
    }

}

private extension RegionViewController {

    func updateState(_ state: RegionModel.ViewState) {
        switch state {
        case .initial:
            break

        case .loading(let state):
            switch state {
            case .start:
                loader.showLoadingOnCenter(inView: tableView)
                tableView.isUserInteractionEnabled = false

            case .stop:
                loader.hideLoading()
                tableView.isUserInteractionEnabled = true

            }

        case .fillingDataState(let data):
            rowSource.sections = data.items
            tableView.reloadData()

        }
    }

    func makeLabel(_ label: RegionModel.Label?) {}

}

// MARK: - UITableViewDelegate

private extension RegionViewController {

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        rowSource.isLastSection(at: .init(row: 0, section: section)) ? 0 : 16
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if rowSource.isLastSection(at: .init(row: 0, section: section)) {
            return nil
        }

        let footer = UIView()
        footer.backgroundColor = UIColor(resource: .backgroundPrimary)

        return footer
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedRow = rowSource.item(at: indexPath) else {
            return
        }

        searchBar.endEditing(true)

        dismiss(animated: true) { [weak self] in
            self?.viewAction.send(.tapCell(selectedRow))
        }
    }

}

// MARK: - UITableViewDataSource

extension RegionViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > .zero {
            searchBarContainer.setState(displayed: true)
        } else if scrollView.contentOffset.y <= .zero {
            searchBarContainer.setState(displayed: false)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        rowSource.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rowSource.numberOfRowsIn(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = rowSource.item(at: indexPath)
        let cell = tableView.dequeueReusable(cell: RegionCell.self, for: indexPath)

        switch row {
        case .city(let city, let selected):
            let subtitle = selected ? Strings.Region.Choose.yourCity : nil
            cell.configure(with: city.name, subtitle: subtitle)
            return cell

        default:
            return UITableViewCell()

        }
    }

}

// MARK: - UISearchBarDelegate

extension RegionViewController {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewAction.send(.inputText(searchText))
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        viewAction.send(.inputText(nil))
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        viewAction.send(.inputText(searchBar.text))
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        viewAction.send(.inputText(nil))
    }

}

// MARK: - Previews

#if DEBUG

private final class MockViewModel: RegionViewModelProtocol {

    @Published var viewState: RegionModel.ViewState = .initial
    @Published var label: RegionModel.Label? = nil

    var viewStatePublisher: Published<RegionModel.ViewState>.Publisher { $viewState }
    var labelPublisher: Published<RegionModel.Label?>.Publisher { $label }

    private var cancellables: Set<AnyCancellable> = []

    func binding(input: RegionModel.BindingInput) -> RegionModel.BindingOutput {
        input.viewAction
            .sink { [weak self] viewAction in
                self?.execute(action: viewAction)
            }
            .store(in: &cancellables)

        return .init(label: labelPublisher.eraseToAnyPublisher(), viewState: viewStatePublisher.eraseToAnyPublisher())
    }

    private func execute(action: RegionModel.ViewAction) {
        if case .viewDidLoad = action {
            viewState = .fillingDataState(.init(items: [.init(items: [
                .city(.init(id: "1", name: "Moscow", location: nil), selected: true),
                .city(.init(id: "2", name: "Saint Petersburg", location: nil), selected: false)
            ])]))
        }
    }

}

@available(iOS 17, *)
#Preview {
    SceneDelegate.setupAppearance()
    return UINavigationController(rootViewController: RegionViewController(viewModel: MockViewModel()))
}

#endif
