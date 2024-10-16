//
//  LocationManager.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import CoreLocation
import Factory

public final class LocationManager: CLLocationManager, LocationManagerProtocol {

    public var success: Success?
    public var fail: Fail?
    public var updatedStatus: VoidClosure?
    public var authStatus: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    private let locationManager = CLLocationManager()

    public func request() {
        delegate = self

        if authStatus == .notDetermined {
            requestWhenInUseAuthorization()
        } else {
            requestLocation()
        }
    }

    public func status() {
        delegate = self

        if authStatus == .notDetermined {
            requestWhenInUseAuthorization()
        } else {
            updatedStatus?()
            updatedStatus = nil
        }
    }

    public func isLocationAvailable() -> Bool {
        switch authStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return true

        default:
            return false

        }
    }

}

extension LocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            updatedStatus?()
            updatedStatus = nil
            requestLocation()
        } else if status == .denied || status == .restricted {
            delegate = nil
            fail?()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate = nil
        fail?()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate = nil
        success?(locations.first)
    }

}

public extension CLAuthorizationStatus {

    var description: String {
        switch self {
        case .authorizedAlways:
            return Strings.SingleLocation.authorizedAlways

        case .authorizedWhenInUse:
            return Strings.SingleLocation.authorizedWhenInUse

        case .denied:
            return Strings.SingleLocation.denied

        case .notDetermined:
            return Strings.SingleLocation.notDetermined

        case .restricted:
            return Strings.SingleLocation.restricted

        default:
            return Strings.SingleLocation.unknown

        }
    }

}

// MARK: - Register container

extension Container {

    var locationManager: Factory<LocationManagerProtocol> {
        self {
            LocationManager()
        }
        .singleton
    }

}
