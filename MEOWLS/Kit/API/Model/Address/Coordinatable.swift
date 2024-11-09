//
//  Coordinatable.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import MapKit

public protocol Coordinatable {

    var latitude: Double { get }
    var longitude: Double { get }
    var coordinate: CLLocationCoordinate2D? { get }
    var location: CLLocation? { get }

}

public extension Coordinatable {

    var coordinate: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation? {
        CLLocation(latitude: latitude, longitude: longitude)
    }

}
