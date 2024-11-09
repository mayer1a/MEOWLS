//
//  SearchView.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import UIKit
import Combine
import SnapKit

final class SearchViewController: NiblessViewController {

    typealias Model = SearchModel

    private let viewModel: SearchViewModelProtocol
    private let viewAction = PassthroughSubject<Model.ViewAction, Never>()
    private var rowSource: ItemsDataSource<Model.Row> = .init()
    private var cancellables: Set<AnyCancellable> = []

    private var searchTagsCalculator: SearchTagsSizeCalculator?

    required init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        binding()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false)
        viewAction.send(.viewWillAppear)
    }

    private lazy var topView = {
        let view = UIView()
        view.backgroundColor = Colors.Background.backgroundWhite.color

        return view
    }()
    private lazy var searchBar = DomainSearchBar()
    private lazy var loader = LoaderWrapper()
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.Background.backgroundWhite.color
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true

        return collectionView
    }()
    private lazy var emptyView: SearchEmptyResultView = {
        let view = SearchEmptyResultView()
        view.isHidden = true

        return view
    }()
    private lazy var closeTapGesture = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(close))
        gesture.isEnabled = true

        return gesture
    }()

}

private extension SearchViewController {

    @objc
    private func close() {
        viewAction.send(.dismiss)
    }

}

private extension SearchViewController {

    func setupUI() {
        title = Strings.Catalogue.Searching.title
        view.backgroundColor = Colors.Shadow.shadowMedium.color
        view.addGestureRecognizer(closeTapGesture)

        setupConstraints()
        registerCell()
    }

    func setupConstraints() {
        view.addSubview(topView)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(searchBar)

        topView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(64)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalToSuperview()
        }
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(36)
            make.directionalHorizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }

    private func registerCell() {
        collectionView.register(cell: ProductCell.self)
        collectionView.register(cell: SearchTagsCollectionCell.self)
        collectionView.register(header: DomainBoldWithButtonCollectionHeader.self)
    }

}

private extension SearchViewController {

    func binding() {
        let input = Model.BindingInput(viewAction: viewAction)
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

private extension SearchViewController {

    func updateState(_ state: Model.ViewState) {
        switch state {
        case .initial(let model):
            if let searchBarConfigureModel = model {
                searchBar.configure(with: searchBarConfigureModel)
            }

        case .loading(let state):
            switch state {
            case .startLoading:
                collectionView.isHidden = false
                emptyView.isHidden = true
                loader.showLoadingOnCenter(inView: collectionView)
                collectionView.isUserInteractionEnabled = false

            case .stopLoading:
                loader.hideLoading()
                collectionView.isUserInteractionEnabled = true

            }

        case .fillingDataState(let fillingDataState):
            fillingState(fillingDataState)

        case .emptyText:
            toggleVisibility(on: true)

        }
    }

    func fillingState(_ state: Model.ViewState.FillingDataState) {
        rowSource.sections = state.items

        if case .categories(let model) = rowSource.item(at: .initial), !model.cellModels.isEmpty {
            searchTagsCalculator = model.tagsCalculator
        } else {
            searchTagsCalculator = nil
        }

        collectionView.isHidden = false
        emptyView.isHidden = !rowSource.isEmpty()
        closeTapGesture.isEnabled = false

        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }

    func toggleVisibility(on isEmtyState: Bool) {
        collectionView.isHidden = isEmtyState
        emptyView.isHidden = isEmtyState
        closeTapGesture.isEnabled = isEmtyState
    }

    func makeLabel(_ label: Model.Label?) {}

}

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let headerModel = rowSource.headerForSection(indexPath.section) as? Model.CollectionHeaderModel else {
            return .init()
        }

        let header = collectionView.dequeueReusable(header: DomainBoldWithButtonCollectionHeader.self, for: indexPath)
        header.configure(with: headerModel.viewModel)

        let hasCategories = headerModel.hasCategories
        let hasCategoriesOrOneSection = !hasCategories || (hasCategories && indexPath.section == 1)
        let isIdentityHeaders = kind == UICollectionView.elementKindSectionHeader
        let hideHeader = hasCategoriesOrOneSection && isIdentityHeaders && headerModel.hasProducts
        header.isHidden = !hideHeader

        return header
    }

}

extension SearchViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        rowSource.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        rowSource.numberOfRowsIn(section: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch rowSource.item(at: indexPath) {
        case .categories(let model):
            let tagsCell = collectionView.dequeueReusable(cell: SearchTagsCollectionCell.self, for: indexPath)
            tagsCell.configure(with: model)

            return tagsCell

        case .product(let model):
            let productCell = collectionView.dequeueReusable(cell: ProductCell.self, for: indexPath)
            productCell.configure(with: model)
            
            return productCell

        default:
            return .init()

        }
    }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        if indexPath == .initial, case .categories = rowSource.item(at: indexPath) {
            let height = searchTagsCalculator?.collectionViewContentSize.height ?? CGFloat.zero
            return CGSize(width: collectionView.bounds.width, height: height)
        }

        return ProductCell.compactSize
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        (rowSource.headerForSection(section) as? Model.CollectionHeaderModel)?.minimumLineSpacing ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        (rowSource.headerForSection(section) as? Model.CollectionHeaderModel)?.minimumLineSpacing ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        (rowSource.headerForSection(section) as? Model.CollectionHeaderModel)?.insetForProductSection ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        let size = CGSize(width: collectionView.bounds.width,
                          height: DomainBoldWithButtonCollectionHeader.prefferedHeight)

        if rowSource.headerForSection(section) is Model.CollectionHeaderModel {
            return size
        }

        return rowSource.numberOfRowsIn(section: section) > 0 ? .zero : size
    }

}

extension SearchViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        dismissKeyboard()

        if scrollView.contentOffset.y > .zero {
            searchBar.configureShadow(needDisplay: true)
        } else if scrollView.contentOffset.y <= .zero {
            searchBar.configureShadow(needDisplay: false)
        }
    }

}

// MARK: - Previews

#if DEBUG

private final class MockViewModel: SearchViewModelProtocol {
    
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
    SearchViewController(viewModel: MockViewModel())
}

#endif
