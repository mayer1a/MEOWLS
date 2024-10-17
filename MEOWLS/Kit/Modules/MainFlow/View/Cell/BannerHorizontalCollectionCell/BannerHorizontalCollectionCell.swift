//
//  BannerHorizontalCollectionCell.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit
import SnapKit

final class BannerHorizontalCollectionCell: NiblessTableViewCell {

    private var state: ViewModel.State = .slider(dataSource: [])

    private var needAutoCorrection: Bool = false

    private var timer: Timer?
    private var lastVisibleCellPath: IndexPath?
    private var isScrolling = false

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        return flowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.register(cell: BannerCollectionViewCell.self)
        collectionView.register(cell: BannerProductCollectionViewCell.self)
        collectionView.register(cell: BannerTagsCollectionCell.self)

        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    deinit {
        timer?.invalidate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if case .automaticSlider = state, let lastVisibleCellPath {
            // Dispatch is needed to fix mixing on some devices
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.scrollToItem(at: lastVisibleCellPath, at: .centeredHorizontally, animated: false)
            }
        }
    }

}

extension BannerHorizontalCollectionCell {

    func configure(with model: ViewModel) {
        state = model.state

        if case .tagsSlider = state {
            flowLayout.estimatedItemSize = model.itemSize
        } else {
            flowLayout.itemSize = model.itemSize
        }

        flowLayout.sectionInset = model.collectionInset
        flowLayout.minimumLineSpacing = model.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = model.minimumLineSpacing

        collectionView.dataSource = self

        needAutoCorrection = model.needAutoCorrection
        
        if case .automaticSlider(let dataSource, _) = state, lastVisibleCellPath == nil {
            lastVisibleCellPath = IndexPath(item: 500 / dataSource.count * dataSource.count, section: 0)
        }

        setupAutomaticScrolling()
    }

}

private extension BannerHorizontalCollectionCell {

    func setupUI() {
        selectionStyle = .none

        setupConstraints()
    }

    func setupConstraints() {
        contentView.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setupAutomaticScrolling() {
        guard case .automaticSlider(_, let interval) = state else {
            return
        }

        timer?.invalidate()

        // miliseconds to seconds
        let seconds = interval / 1000
        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }

            if !self.isScrolling {
                DispatchQueue.main.async { [weak self] in
                    guard let self else {
                        timer.invalidate()
                        return
                    }
                    self.scrollNext(true)
                }
            }
        }
        self.timer = timer
    }

    func scrollNext(_ animated: Bool) {
        let lastIndexPath = lastVisibleCellPath ?? IndexPath(item: 0, section: 0)
        let newIndexPath = IndexPath(item: lastIndexPath.row + 1, section: lastIndexPath.section)

        if collectionView.cellForItem(at: newIndexPath) != nil {
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: animated)
            lastVisibleCellPath = newIndexPath
        }
    }

}

extension BannerHorizontalCollectionCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .automaticSlider:
            return Int.max

        case .slider(let dataSource):
            return dataSource.count

        case .productSlider(let dataSource):
            return dataSource.count

        case .tagsSlider(let dataSource):
            return dataSource.count

        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch state {
        case .automaticSlider(let dataSource, _):
            let cell = collectionView.dequeueReusable(cell: BannerCollectionViewCell.self, for: indexPath)
            cell.configure(with: dataSource[indexPath.row % dataSource.count])

            return cell

        case .slider(let dataSource):
            let cell = collectionView.dequeueReusable(cell: BannerCollectionViewCell.self, for: indexPath)
            cell.configure(with: dataSource[indexPath.row])

            return cell

        case .productSlider(let dataSource):
            let cell = collectionView.dequeueReusable(cell: BannerProductCollectionViewCell.self, for: indexPath)
            cell.configure(with: dataSource[indexPath.row])

            return cell

        case .tagsSlider(let dataSource):
            let cell = collectionView.dequeueReusable(cell: BannerTagsCollectionCell.self, for: indexPath)
            cell.configure(with: dataSource[indexPath.row])

            return cell
            
        }
    }

}

extension BannerHorizontalCollectionCell: UICollectionViewDelegate {

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
        timer?.invalidate()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        finishScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            finishScrolling()
        }
    }

    private func finishScrolling() {
        guard needAutoCorrection else {
            return
        }

        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let nearestCellPoint = CGPoint(x: visibleRect.midX + flowLayout.minimumInteritemSpacing, y: visibleRect.midY)

        if let visibleIndexPath = collectionView.indexPathForItem(at: visiblePoint) {

            collectionView.scrollToItem(at: visibleIndexPath, at: .centeredHorizontally, animated: true)
            lastVisibleCellPath = visibleIndexPath

        } else if let visibleIndexPath = collectionView.indexPathForItem(at: nearestCellPoint) {

            collectionView.scrollToItem(at: visibleIndexPath, at: .centeredHorizontally, animated: true)
            lastVisibleCellPath = visibleIndexPath

        }

        isScrolling = false
        setupAutomaticScrolling()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch state {
        case .productSlider(let dataSource):
            dataSource[indexPath.row].productTapClosure?()

        default:
            break

        }
    }

}
