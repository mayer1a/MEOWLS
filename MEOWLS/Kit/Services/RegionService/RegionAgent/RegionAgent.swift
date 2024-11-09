//
//  RegionAgent.swift
//  MEOWLS
//
//  Created by Artem Mayer on 16.09.2024.
//

import UIKit
import CoreLocation
import Factory

/// Determines the user's region by coordinates, or by default (if geolocation is prohibited)
final class RegionAgent: RegionAgentProtocol {

    private let apiWrapper: APIWrapperProtocol
    var cachedRegions: [City]?

    fileprivate init(apiWrapper: APIWrapperProtocol) {
        self.apiWrapper = apiWrapper
    }

    func invalidate() {
        cachedRegions = nil
    }

    func requestCurrentRegion(completion: RegionCompletion? = nil, networkError: NetworkError? = nil) {
        apiWrapper.cities { [weak self] response in
            if let regions = response.data {
                self?.cachedRegions = regions
                let defaultRegion = regions.first
                completion?(defaultRegion, regions)
            } else {
                switch response.dataResponse?.result {
                case .failure(let err):
                    if (err as NSError).code == -1200 {
                        completion?(nil, [])
                    } else {
                        networkError?(response.code, response.error)
                    }

                default:
                    networkError?(response.code, response.error)

                }
            }
        }
    }

    func downloadRegions(completion: VoidClosure? = nil) {
        apiWrapper.cities { [weak self] response in
            guard
                let self,
                let regions = response.data
            else {
                return
            }

            self.cachedRegions = regions
            completion?()
        }
    }

    func nearest(of cities: [City], to location: CLLocation?) -> City? {
        guard let location else { return nil }

        return cities.sorted {
            guard
                let leftCoordinate = $0.location?.coordinate,
                let rightCoordinate = $1.location?.coordinate
            else {
                return false
            }

            let leftLocation = CLLocation(latitude: leftCoordinate.latitude, longitude: leftCoordinate.longitude)
            let rightLocation = CLLocation(latitude: rightCoordinate.latitude, longitude: rightCoordinate.longitude)
            return leftLocation.distance(from: location) < rightLocation.distance(from: location)
        }.first
    }

}

// MARK: - Register container

extension Container {

    var regionAgent: Factory<RegionAgentProtocol> {
        self {
            RegionAgent(apiWrapper: resolve(\.apiWrapper))
        }
        .singleton
    }

}
