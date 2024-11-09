//
//  MainViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import Combine

public protocol MainViewModelProtocol: AnyObject {

    typealias Model = MainModel
    typealias Constants = MainModel.Constants

    var viewStatePublisher: Published<Model.ViewState>.Publisher { get }
    var labelPublisher: Published<Model.Label?>.Publisher { get }

    func binding(input: Model.BindingInput) -> Model.BindingOutput

}
