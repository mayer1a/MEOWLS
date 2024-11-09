//
//  SearchTagsCollectionCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

final class SearchTagsCollectionCell: NiblessCollectionViewCell {

    private var searchTagsCalculator: SearchTagsSizeCalculator?
    private var selectCategoryHandler: ((_ categoryIndex: Int) -> ())?
    private var tagCellModels: [SearchTagCell.ViewModel] = [] {
        didSet {
            if let searchTagsCalculator {
                let searchTagsLayout = SearchTagsCollectionLayout(calculator: searchTagsCalculator)

                collectionView.setCollectionViewLayout(searchTagsLayout, animated: false)
                collectionView.collectionViewLayout.invalidateLayout()
                collectionView.reloadData()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Colors.Background.backgroundWhite.color
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: SearchTagCell.self)

        return collectionView
    }()

}

extension SearchTagsCollectionCell {

    func configure(with model: SearchTagsCollectionCell.ViewModel) {
        searchTagsCalculator = model.tagsCalculator
        tagCellModels = model.cellModels
        selectCategoryHandler = model.selectCategoryHandler
    }

}

private extension SearchTagsCollectionCell {

    func setupUI() {
        contentView.backgroundColor = Colors.Background.backgroundWhite.color
        contentView.addSubview(collectionView)

        setupConstraints()
    }

    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

}

extension SearchTagsCollectionCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagCellModels.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusable(cell: SearchTagCell.self, for: indexPath)
        cell.configure(with: tagCellModels[indexPath.row])

        return cell
    }

}

extension SearchTagsCollectionCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectCategoryHandler?(indexPath.row)
    }

}
