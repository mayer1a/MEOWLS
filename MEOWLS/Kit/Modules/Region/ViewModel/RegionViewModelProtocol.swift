//
//  RegionViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Combine

protocol RegionViewModelProtocol: AnyObject {

    typealias Model = RegionModel

    var viewStatePublisher: Published<Model.ViewState>.Publisher { get }
    var labelPublisher: Published<Model.Label?>.Publisher { get }

    func binding(input: Model.BindingInput) -> Model.BindingOutput

}
