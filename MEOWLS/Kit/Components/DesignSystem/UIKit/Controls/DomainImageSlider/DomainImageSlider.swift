//
//  DomainImageSlider.swift
//  MEOWLS
//
//  Created by Artem Mayer on 25.10.2024.
//

import UIKit
import Kingfisher
import SnapKit

public final class DomainImageSlider: NiblessControl {

    public var onSliderPageSelected: ParametersClosure<Int, UIImageView?>?
    public var onScrollToPage: ParameterClosure<Int>?
    public var placeholderImage: UIImage? = UIImage(resource: .itemLong)
    public var currentPageIndicatorTintColor: UIColor?
    public var pageIndicatorTintColor: UIColor?
    public var isCircular: Bool = false
    public var bottomInset: CGFloat = 24
    public var sliderUnderContent: Bool = false {
        didSet {
            if sliderUnderContent {
                collectionView.snp.remakeConstraints { make in
                    make.top.directionalHorizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview().inset(bottomInset)
                }
            } else {
                collectionView.snp.remakeConstraints { make in
                    make.top.directionalHorizontalEdges.equalToSuperview()
                    make.bottom.equalToSuperview().inset(bottomInset)
                }
            }
        }
    }
    public var showGradient: Bool = true {
        didSet {
            gradient.isHidden = !showGradient
        }
    }

    public override init() {
        super.init()

        setupUI()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        setupLayoutGradient()

        if primaryVisiblePage == 0, isCircular {
            scrollToPage(images.count * imageBufferSize / 2)
        }
    }

    private var images: [ItemImage] = []
    private var maximumNumberOfImages: Int = 12
    private var imageBufferSize: Int = 4
    private var itemsCount: Int {
        if isCircular, images.count > 1 {
            return images.count * imageBufferSize
        } else {
            return images.count
        }
    }
    private var primaryVisiblePage: Int {
        if collectionView.bounds.size.width > 0 {
            let xOffset = collectionView.contentOffset.x
            let width = collectionView.bounds.size.width
            return Int(xOffset + width / 2) / Int(width) % images.count
        } else {
            return 0
        }
    }

    private lazy var gradient = UIView()
    private lazy var pageControl = DomainPageControl()
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: DomainImageSliderCell.self)

        return collectionView
    }()

}

public extension DomainImageSlider {

    func set(imageSources: [ItemImage]) {
        let imagesCount = min(imageSources.count, maximumNumberOfImages)

        gradient.isHidden = !showGradient || imagesCount < 2

        images = imagesCount > 0 ? Array(imageSources.prefix(imagesCount)) : [ItemImage()]
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.accessibilityIdentifier = "image_slider_page_indicator"

        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.isUserInteractionEnabled = images.count > 1
        collectionView.isAccessibilityElement = true
        collectionView.accessibilityIdentifier = "image_slider"
    }

    func scrollToPage(_ page: Int) {
        guard collectionView.numberOfItems(inSection: 0) > page else {
            return
        }

        collectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .left, animated: false)
        pageControl.currentPage = page
        onScrollToPage?(page)
    }

}

private extension DomainImageSlider {

    func setupUI() {
        backgroundColor = UIColor.clear
        collectionView.backgroundColor = UIColor.clear

        gradient.backgroundColor = UIColor.clear
        gradient.isUserInteractionEnabled = false

        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.hidesForSinglePage = true
        pageControl.isUserInteractionEnabled = false

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(collectionView)
        addSubview(gradient)
        addSubview(pageControl)

        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        gradient.snp.makeConstraints { make in
            make.bottom.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(40)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
    }

    func setupLayoutGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradient.bounds
        gradientLayer.colors = [
            UIColor(resource: .backgroundWhite).withAlphaComponent(0).cgColor,
            UIColor(resource: .backgroundWhite).cgColor
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradient.layer.insertSublayer(gradientLayer, at: 0)
    }

}

extension DomainImageSlider: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {

        collectionView.bounds.size
    }

    public func collectionView(_ collectionView: UICollectionView,
                               didEndDisplaying cell: UICollectionViewCell,
                               forItemAt indexPath: IndexPath) {

        (cell as? DomainImageSliderCell)?.cancelLoading()
    }

}

extension DomainImageSlider: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = primaryVisiblePage
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        onScrollToPage?(primaryVisiblePage)

        if isCircular && (primaryVisiblePage == 0 || primaryVisiblePage == images.count - 1) {
            scrollToPage(itemsCount / 2 + primaryVisiblePage)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let visibleCell = self.collectionView.visibleCells.first as? DomainImageSliderCell
        self.onSliderPageSelected?(pageControl.currentPage, visibleCell?.imageView)
    }

}

extension DomainImageSlider: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsCount
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusable(cell: DomainImageSliderCell.self, for: indexPath)
        cell.set(image: images[indexPath.row % images.count], placeholder: placeholderImage)

        return cell
    }

}
