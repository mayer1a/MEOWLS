//
//  SearchTagsSizeCalculator.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

final class SearchTagsSizeCalculator {

    typealias CategoriesWithFrame = [(tagCellModel: SearchTagCell.ViewModel, frame: CGRect)]

    private(set) var categoriesWithSize: CategoriesWithFrame = []
    // Collection content size
    var collectionViewContentSize: CGSize {
        CGSize(width: contentWidth, height: contentHeight)
    }

    private static let cellPadding: CGFloat = 4
    private static let horizontalPadding: CGFloat = 12
    private static let horizontalStackSpacing: CGFloat = 10
    private static let edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 16, right: 10)
    private static let titleFont = UIFont.systemFont(ofSize: 14)
    private static let subtitleFont = UIFont.systemFont(ofSize: 10)
    private static let valueFont = UIFont.systemFont(ofSize: 12)
    private static let cellHeight: CGFloat = 45

    private static let sizeCalculationLabel = UILabel(frame: .zero)

    private var tagsCellsModels: [SearchTagCell.ViewModel]
    private let collectionViewWidth: CGFloat
    private var contentWidth: CGFloat {
        collectionViewWidth - SearchTagsSizeCalculator.edgeInsets.left + SearchTagsSizeCalculator.edgeInsets.right
    }
    private var contentHeight: CGFloat = 0

    init(tagsCellsModels: [SearchTagCell.ViewModel], collectionViewWidth: CGFloat) {
        self.tagsCellsModels = tagsCellsModels
        self.collectionViewWidth = collectionViewWidth
        calculateSizes()
    }

    private func calculateSizes() {
        categoriesWithSize = []
        let cellHeight = SearchTagsSizeCalculator.cellHeight
        let cellPadding = SearchTagsSizeCalculator.cellPadding
        let edgeInsets = SearchTagsSizeCalculator.edgeInsets
        let rowHeight: CGFloat = cellPadding * 2 + cellHeight

        var yOffset: CGFloat = edgeInsets.top
        var xOffset: CGFloat = edgeInsets.left

        tagsCellsModels.forEach { tagCellModel in
            let width = calculateSize(for: tagCellModel).width + 2 * cellPadding

            if xOffset + width > contentWidth {
                // Transfer to a new line
                xOffset = edgeInsets.left
                yOffset += rowHeight
            }

            let frame = CGRect(x: xOffset, y: yOffset, width: width, height: rowHeight)
                .insetBy(dx: cellPadding, dy: cellPadding)
            categoriesWithSize.append((tagCellModel, frame))

            xOffset += width
            contentHeight = max(contentHeight, yOffset + rowHeight)
        }
    }

    private func calculateSize(for tagCellModel: SearchTagCell.ViewModel) -> CGSize {
        let cellInset = SearchTagsSizeCalculator.horizontalPadding
        let cellHeight = SearchTagsSizeCalculator.cellHeight
        var width: CGFloat = 0

        // Calculate the width for the category name
        let label = SearchTagsSizeCalculator.sizeCalculationLabel
        label.font = SearchTagsSizeCalculator.titleFont
        label.attributedText = tagCellModel.title
        label.sizeToFit()
        width = label.bounds.width

        // Calculate the width for the subcategories
        label.font = SearchTagsSizeCalculator.subtitleFont
        label.attributedText = tagCellModel.subtitle
        label.sizeToFit()
        width = max(width, label.bounds.width)

        // Add padding and width to the value
        width += SearchTagsSizeCalculator.horizontalStackSpacing // Space between elements
        label.font = SearchTagsSizeCalculator.valueFont
        label.text = tagCellModel.value
        label.sizeToFit()
        width += label.bounds.width

        return CGSize(width: width + cellInset * 2, height: cellHeight)
    }
    
}
