//
//  IntroViewModelProtocol.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.09.2024.
//

import Foundation

protocol IntroViewModelProtocol: ObservableObject {

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isStore: Bool { get }

    func viewDidLoad()
    func viewDidAppear()

}
