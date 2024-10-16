//
//  LocationManagerProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import CoreLocation

public protocol LocationManagerProtocol {

    typealias Success = (CLLocation?) -> Void
    typealias Fail = () -> Void

    var success: Success? { get set }
    var fail: Fail? { get set }
    var updatedStatus: VoidClosure? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var authStatus: CLAuthorizationStatus { get }

    func request()
    func status()
    func isLocationAvailable() -> Bool

}
