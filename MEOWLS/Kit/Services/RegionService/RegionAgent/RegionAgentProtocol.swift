//
//  RegionAgentProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import UIKit
import CoreLocation

protocol RegionAgentProtocol: AnyObject {

    typealias RegionCompletion = (City?, [City]) -> Void
    typealias NetworkError = (Int?, String?) -> Void

    var cachedRegions: [City]? { get set }

    func invalidate()
    func requestCurrentRegion(completion: RegionCompletion?, networkError: NetworkError?)
    func downloadRegions(completion: VoidClosure?)
    func nearest(of cities: [City], to location: CLLocation?) -> City?

}
