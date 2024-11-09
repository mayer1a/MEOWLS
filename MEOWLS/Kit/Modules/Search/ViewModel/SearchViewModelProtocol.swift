//
//  SearchViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.10.2024.
//

import Foundation

protocol SearchViewModelProtocol: AnyObject {

    typealias Model = SearchModel

    var viewStatePublisher: Published<Model.ViewState>.Publisher { get }
    var labelPublisher: Published<Model.Label?>.Publisher { get }

    func binding(input: Model.BindingInput) -> Model.BindingOutput

}
