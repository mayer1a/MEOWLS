//
//  UIView+rotateLoader.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.09.2024.
//

import UIKit

public extension UIView {

    private static let loaderRotationAnimationKey = "loaderRotationAnimationKey"

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: UIView.loaderRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: UIView.loaderRotationAnimationKey)
        }
    }

    func stopRotating() {
        if layer.animation(forKey: UIView.loaderRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.loaderRotationAnimationKey)
        }
    }
    
}
