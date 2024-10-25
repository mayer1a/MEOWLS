//
//  DomainPageControl.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit
import SnapKit

final class DomainPageControl: NiblessControl {

    var currentPage: Int {
        set {
            if newValue < numberOfPages, newValue >= 0, newValue != _currentPage {
                _currentPage = newValue
            }
        }
        get {
            _currentPage
        }
    }
    var numberOfPages: Int {
        set {
            if newValue >= 0, newValue != _numberOfPages {
                _numberOfPages = newValue
            }
        }
        get {
            _numberOfPages
        }
    }
    var hidesForSinglePage: Bool = false
    var pageIndicatorTintColor: UIColor?
    var currentPageIndicatorTintColor: UIColor?

    private let estimatedHeight: CGFloat
    private let defaultPageIndicatorColor: UIColor = UIColor(resource: .iconSecondary)
    private let defaultCurrentPageIndicatorColor: UIColor = UIColor(resource: .accentPrimary)
    private var oldDotIndex: Int = 0

    private var _currentPage: Int = 0 {
        didSet {
            oldDotIndex = oldValue
            updateDots()
        }
    }
    private var _numberOfPages: Int = 0 {
        didSet {
            configure()
        }
    }
    private let horizontalInset: CGFloat = 10
    private let verticalInset: CGFloat = 5
    private lazy var dotHeight = estimatedHeight - verticalInset * 2
    private lazy var ovalDotWidth: CGFloat = dotHeight * 2.5

    // MARK: - Initializers

    init(estimatedHeight: CGFloat = 14) {
        self.estimatedHeight = estimatedHeight <= 14 ? 14 : estimatedHeight

        super.init(frame: .zero)

        setupUI()
    }

    // MARK: - UI

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizesSubviews = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return blurEffectView
    }()
    private lazy var dotsContainer: UIStackView = {
        let view = UIStackView()
        view.spacing = dotHeight > 4 ? dotHeight * 0.5 : 4

        return view
    }()

}

private extension DomainPageControl {

    func setupUI() {
        layer.cornerRadius = estimatedHeight / 2
        layer.masksToBounds = true
        backgroundColor = .clear

        setupConstraints()
    }

    func setupConstraints() {
        addSubview(blurEffectView)
        addSubview(dotsContainer)

        dotsContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(horizontalInset)
            make.directionalVerticalEdges.equalToSuperview().inset(verticalInset)
            make.height.equalTo(dotHeight)
        }
    }

    private func configure() {
        removeDots()

        if (numberOfPages == 1 && hidesForSinglePage) || numberOfPages <= 0 {
            isHidden = true
        } else {
            isHidden = false
            createDots()
        }
    }

    private func updateDots() {
        let dotsCount = dotsContainer.arrangedSubviews.count
        guard dotsCount > oldDotIndex, dotsCount > currentPage else {
            return
        }

        let oldDot = dotsContainer.arrangedSubviews[oldDotIndex]
        let newDot = dotsContainer.arrangedSubviews[currentPage]
        let oldDotColor = pageIndicatorTintColor ?? defaultPageIndicatorColor
        let newDorColor = currentPageIndicatorTintColor ?? defaultCurrentPageIndicatorColor

        oldDot.snp.remakeConstraints({ $0.size.equalTo(dotHeight) })
        newDot.snp.remakeConstraints { make in
            make.width.equalTo(ovalDotWidth)
            make.height.equalTo(dotHeight)
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut]) { [weak self] in
            oldDot.backgroundColor = oldDotColor
            newDot.backgroundColor = newDorColor
            self?.dotsContainer.layoutIfNeeded()
        }
    }

    func removeDots() {
        dotsContainer.arrangedSubviews.forEach { subview in
            dotsContainer.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }

}

// MARK: - Create dots helper

private extension DomainPageControl {

    func createDots() {
        (0..<numberOfPages).forEach { index in
            let dot = createDot(isOval: index == 0)
            dotsContainer.addArrangedSubview(dot)
        }
    }

    func createDot(isOval: Bool) -> UIView {
        var view: UIView

        if isOval {
            view = UIView(frame: .init(x: 0, y: 0, width: ovalDotWidth, height: dotHeight))
            view.backgroundColor = currentPageIndicatorTintColor ?? defaultCurrentPageIndicatorColor
            view.snp.makeConstraints { make in
                make.width.equalTo(ovalDotWidth)
                make.height.equalTo(dotHeight)
            }
        } else {
            view = UIView(frame: .init(x: 0, y: 0, width: dotHeight, height: dotHeight))
            view.backgroundColor = pageIndicatorTintColor ?? defaultPageIndicatorColor
            view.snp.makeConstraints({ $0.size.equalTo(dotHeight) })
        }

        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true

        return view
    }

}
