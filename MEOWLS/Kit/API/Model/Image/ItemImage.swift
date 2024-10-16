//
//  ItemImage.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import UIKit

public protocol CustomImageSource {

    var url: String? { get }
    var video: String? { get }

}

public struct ImageSource: CustomImageSource {

    public var url: String?
    public var video: String?

}

public enum ImageScaleFactor {
    case original
    case screen
    case points(CGFloat)
    case pixels(CGFloat)
}

public struct ItemImage: Codable {

    public let small: String?
    public let medium: String?
    public let large: String?
    public let original: String?
    public let dimension: ImageDimensionDTO?

    private var scaledSorted: [ImageSize] {
        ImageSize.allCases.sorted(by: { (left, right) in left.rawValue < right.rawValue })
    }

    public var smallest: String? {
        small ?? medium ?? large ?? original
    }

}

public extension ItemImage {

    func scale(factor: ImageScaleFactor) -> CustomImageSource {
        let accuracy: CGFloat = 0.9
        switch factor {
        case .original:
            return ImageSource(url: original)

        case .screen:
            let fullWidth = UIScreen.main.bounds.width * UIScreen.main.scale
            return suitableImage(width: accuracy * fullWidth)

        case .points(let widthInPoints):
            let targetWidth = widthInPoints * UIScreen.main.scale
            return suitableImage(width: accuracy * targetWidth)

        case .pixels(let withInPixels):
            return suitableImage(width: accuracy * withInPixels)

        }
    }

    private func suitableImage(width: CGFloat) -> CustomImageSource {
        let imageStringURL: String?
        if let suitableImage = scaledSorted.first(where: { CGFloat($0.rawValue) >= width }) {
            switch suitableImage {
            case .small:
                imageStringURL = small

            case .medium:
                imageStringURL = medium

            case .large:
                imageStringURL = large

            case .original:
                imageStringURL = original

            }
        } else {
            imageStringURL = original
        }
        return ImageSource(url: imageStringURL)
    }

    private enum ImageSize: Int, CaseIterable {
        case small = 120
        case medium = 360
        case large = 640
        case original = 1024
    }

}

extension ItemImage: Equatable {

    public static func == (lhs: ItemImage, rhs: ItemImage) -> Bool {
        lhs.small == rhs.small && lhs.medium == rhs.medium && lhs.large == rhs.large && lhs.original == rhs.original
    }

}
