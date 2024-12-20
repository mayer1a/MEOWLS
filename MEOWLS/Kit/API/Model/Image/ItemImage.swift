//
//  ItemImage.swift
//  MEOWLS
//
//  Created by Artem Mayer on 24.07.2024.
//

import UIKit

public protocol CustomImageSourceProtocol {

    var url: String? { get }
    var video: String? { get }

}

public struct CustomImageSource: CustomImageSourceProtocol {

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

    init(original: String? = nil) {
        self.original = original
        self.small = nil
        self.medium = nil
        self.large = nil
        self.dimension = nil
    }

    private var scaledSorted: [ImageSize] {
        ImageSize.allCases.sorted(by: { (left, right) in left.rawValue < right.rawValue })
    }

    public var smallest: String? {
        small ?? medium ?? large ?? original
    }

}

public extension ItemImage {

    func scale(factor: ImageScaleFactor) -> CustomImageSourceProtocol {
        let accuracy: CGFloat = 0.9
        switch factor {
        case .original:
            return CustomImageSource(url: original)

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

    private func suitableImage(width: CGFloat) -> CustomImageSourceProtocol {
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
        return CustomImageSource(url: imageStringURL ?? original)
    }

    private enum ImageSize: Int, CaseIterable {
        case small = 192
        case medium = 480
        case large = 700
        case original = 1024
    }

}

extension ItemImage: Equatable {

    public static func == (lhs: ItemImage, rhs: ItemImage) -> Bool {
        lhs.small == rhs.small && lhs.medium == rhs.medium && lhs.large == rhs.large && lhs.original == rhs.original
    }

}
