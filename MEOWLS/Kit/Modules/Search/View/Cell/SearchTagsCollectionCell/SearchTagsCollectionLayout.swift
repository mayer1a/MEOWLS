//
//  SearchTagsCollectionLayout.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import UIKit

final class SearchTagsCollectionLayout: NiblessCollectionViewLayout {

    private var calculator: SearchTagsSizeCalculator
    private var cache: [UICollectionViewLayoutAttributes]

    init(calculator: SearchTagsSizeCalculator) {
        self.calculator = calculator
        self.cache = []

        super.init()
    }

    override var collectionViewContentSize: CGSize {
        calculator.collectionViewContentSize
    }

    // Preparing cached attributes
    override func prepare() {
        cache.removeAll()
        calculator.categoriesWithSize.enumerated().forEach { index, item in
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = item.frame
            cache.append(attributes)
        }
    }

    // Attributes for elements in a tag
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        cache.filter { $0.frame.intersects(rect) }
    }

    // Attributes for a single element
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        indexPath.item < cache.count ? cache[indexPath.item] : nil
    }

}
