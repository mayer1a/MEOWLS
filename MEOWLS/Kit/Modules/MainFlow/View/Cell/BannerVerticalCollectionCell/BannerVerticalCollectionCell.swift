//
//  BannerVerticalCollectionCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import SnapKit

public final class BannerVerticalCollectionCell: NiblessTableViewCell {

    private var dataSource = [CollectionItem]()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.setupUI()
    }

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(cell: BannerCollectionViewCell.self)

        return collectionView
    }()

}

public extension BannerVerticalCollectionCell {

    func configure(with model: ViewModel) {
        flowLayout.sectionInset = model.collectionInset
        flowLayout.minimumInteritemSpacing = model.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = model.minimumLineSpacing
        dataSource = model.dataSource

        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

private extension BannerVerticalCollectionCell {

    func setupUI() {
        selectionStyle = .none

        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

}

extension BannerVerticalCollectionCell: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusable(cell: BannerCollectionViewCell.self, for: indexPath)
        cell.configure(with: dataSource[indexPath.row].cellModel)

        return cell
    }

}

extension BannerVerticalCollectionCell: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        dataSource[indexPath.row].size
    }

}
