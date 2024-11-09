//
//  ShadowableView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import UIKit
import SnapKit

public final class ShadowableView: NiblessControl {

    public override init() {
        super.init()

        setupUI()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public func setState(displayed: Bool) {
        guard displayed && layer.shadowOpacity == .zero || !displayed && layer.shadowOpacity == 1.0 else {
            return
        }

        if layer.shadowPath == nil {
            setupShadowPath()
        }

        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = layer.shadowOpacity
        animation.toValue = displayed ? 1.0 : 0.0
        animation.duration = 0.15
        layer.add(animation, forKey: animation.keyPath)
        layer.shadowOpacity = displayed ? 1.0 : 0.0
    }

    public func addCustomSubview(_ view: UIView, setupConstraints: (_ make: ConstraintMaker) -> Void) {
        addSubview(view)
        view.snp.makeConstraints(setupConstraints)
    }

}

extension ShadowableView {

    private func setupUI() {
        backgroundColor = Colors.Background.backgroundWhite.color
    }

    private func setupShadowPath() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = 12.0
        layer.shadowColor = Colors.Shadow.shadowSmall.color.cgColor

        let originY = bounds.maxY - layer.shadowRadius
        let containerRect = CGRect(x: 0, y: originY, width: bounds.width, height: layer.shadowRadius)
        layer.shadowPath = UIBezierPath(rect: containerRect).cgPath
    }

}
