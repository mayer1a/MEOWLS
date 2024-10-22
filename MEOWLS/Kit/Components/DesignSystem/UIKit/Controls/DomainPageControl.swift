//
//  DomainPageControl.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

public final class DomainPageControl: UIPageControl {

    private var backgroundLayer: CAShapeLayer?
    private let padding: CGFloat = 4
    private let spacing: CGFloat = 10
    private let horizontalInsets: CGFloat = 10
    private let verticalInsets: CGFloat = 2

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        backgroundLayer?.frame = CGRect(x: coordinateX, y: coordinateY, width: width, height: height)
    }

    private var initialHorizontalPosition: CGFloat {
        (bounds.width - width) / 2
    }
    private var coordinateX: CGFloat {
        initialHorizontalPosition - padding
    }
    private var coordinateY: CGFloat {
        (bounds.height - verticalInsets) / 2 - padding
    }
    private var width: CGFloat {
        let totalWidth = CGFloat(numberOfPages - 1) * spacing + horizontalInsets
        return totalWidth + 2 * padding
    }
    private var height: CGFloat {
        verticalInsets + 2 * padding
    }

    public override var currentPage: Int {
        didSet {
            setupDots()
        }
    }

    public override var numberOfPages: Int {
        didSet {
            setupDots()
        }
    }

    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true

        return blurEffectView
    }()

}

private extension DomainPageControl {

    func setupUI() {
        pageIndicatorTintColor = UIColor(resource: .iconSecondary)
        currentPageIndicatorTintColor = UIColor(resource: .accentPrimary)

        setupConstraints()
    }

    func setupConstraints() {
        view.insertSubview(blurEffectView, at: 0)
        
        blurEffectView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(5)
            make.horizontalEdges.equalToSuperview().inset(25)
        }
    }

    func setupDots() {
        backgroundLayer?.removeFromSuperlayer()

        backgroundLayer = CAShapeLayer()
        backgroundLayer?.fillColor = UIColor(resource: .textTertiary).cgColor
        backgroundLayer?.cornerRadius = padding
        layer.insertSublayer(backgroundLayer!, at: 0)
    }

}

