//
//  IntroChildViewModelProtocol.swift
//  POS
//
//  Created by Artem Mayer on 04.09.2024.
//

import Combine
import UIKit

public protocol IntroChildViewModelProtocol: ObservableObject {

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var showRoutePublisher: Published<IntroModel.Route?>.Publisher { get }

    func viewDidLoad(in viewController: UIViewController?)
    func viewDidAppear()

}
