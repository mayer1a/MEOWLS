//
//  SearchTagsCollectionCellViewModel.swift
//  MEOWLS
//
//  Created by Artem Mayer on 18.10.2024.
//

import Foundation

extension SearchTagsCollectionCell {

    struct ViewModel {

        let tagsCalculator: SearchTagsSizeCalculator?
        let cellModels: [SearchTagCell.ViewModel]
        let selectCategoryHandler: (_ categoryIndex: Int) -> ()

        init(calculator: SearchTagsSizeCalculator? = nil,
             cellModels: [SearchTagCell.ViewModel],
             categoryHandler: @escaping (_ categoryIndex: Int) -> ()) {

            self.tagsCalculator = calculator
            self.cellModels = cellModels
            self.selectCategoryHandler = categoryHandler
        }

    }

}
