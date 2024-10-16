//
//  RegionViewModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Foundation
import Combine
import CoreLocation

final class RegionViewModel: RegionViewModelProtocol {

    @Published private var viewState: Model.ViewState = .initial
    @Published private var label: Model.Label? = nil

    var viewStatePublisher: Published<Model.ViewState>.Publisher { $viewState }
    var labelPublisher: Published<Model.Label?>.Publisher { $label }

    private var selectedCityHandler: ((City?) -> Void)?
    private let regionAgent: RegionAgentProtocol
    private let router: RegionRouterProtocol
    private let apiService: RegionApiServiceProtocol
    private var locationManager: LocationManagerProtocol
    private var cancellables: Set<AnyCancellable> = []
    private lazy var serialQueue = DispatchQueue(label: "com.meowls.regionFilter", qos: .userInitiated)

    private var cities: [City]
    private var filteredCities: [City]?
    private var selectedCity: City?

    private var searchTextReplacements: [String: String] { return ["ё": "е"] }

    init(with model: Model.InitialModel) {
        self.router = model.router
        self.apiService = model.apiService
        self.regionAgent = model.regionAgent
        self.locationManager = model.locationManager
        self.cities = model.inputModel.cities
        self.selectedCity = model.inputModel.selectedCity
        self.selectedCityHandler = model.inputModel.selectedCityHandler

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

}

extension RegionViewModel {

    private func getUserLocation() {
        locationManager.fail = { [weak self] in
            let handler: VoidClosure = { [weak self] in
                guard let self else { return }

                router.open(.confirmationRegionDialog(city: cities.first, handler: { [weak self] in
                    self?.selectedCityHandler?(self?.selectedCity)
                }))
            }

            self?.router.open(.locationErrorDialog(model: .init(message: "Error computing location", handler: handler)))
        }

        locationManager.success = { [weak self] location in
            guard let self else { return }

            let nearestRegion = regionAgent.nearest(of: cities, to: location)
            router.open(.confirmationRegionDialog(city: nearestRegion, handler: { [weak self] in
                self?.selectedCityHandler?(self?.selectedCity)
            }))
        }

        locationManager.request()
    }

    private func filter(with filterText: String?) {
        viewState = .loading(.start)

        serialQueue.async { [weak self] in
            guard let self else { return }

            if let filter = normalized(searchText: filterText), !filter.isEmpty {
                filteredCities = cities.filter({ self.normalized(searchText: $0.name)?.contains(filter) ?? false })
            } else {
                filteredCities = nil
            }

            viewState = .loading(.stop)
            buildSections()
        }
    }

    private func normalized(searchText: String?) -> String? {
        guard let searchText else { return nil }

        let allowedCharacterSet = CharacterSet.letters
        var normalizedText = searchText.lowercased()
        searchTextReplacements.forEach {
            normalizedText = normalizedText.replacingOccurrences(of: $0.key, with: $0.value)
        }
        normalizedText = normalizedText.components(separatedBy: allowedCharacterSet.inverted).joined()
        return normalizedText
    }

    private func buildSections() {
        var sections = Model.Section()

        if let filteredCities {
            sections.items = filteredCities.map({ .city($0, selected: $0 == selectedCity) })

        } else if let selectedCity, !cities.isEmpty {
            sections.items.append(.city(selectedCity, selected: true))
            var regionsExceptSelected = cities

            regionsExceptSelected.removeAll(where: { $0 == selectedCity })
            sections.items.append(contentsOf: regionsExceptSelected.map {
                .city($0, selected: false)
            })

        } else {
            sections.items.append(contentsOf: cities.map({ .city($0, selected: $0 == selectedCity) }))
        }

        viewState = .fillingDataState(.init(items: [sections]))
    }

}

extension RegionViewModel {

    func binding(input: Model.BindingInput) -> Model.BindingOutput {
        input.viewAction
            .sink { [weak self] action in
                self?.execute(action: action)
            }
            .store(in: &cancellables)
        
        return .init(label: labelPublisher.eraseToAnyPublisher(), viewState: viewStatePublisher.eraseToAnyPublisher())
    }

    private func execute(action: Model.ViewAction) {
        switch action {
        case .viewDidLoad:
            buildSections()

        case .tapCell(let row):
            if case .city(let city, _) = row {
                selectedCityHandler?(city)
            }

        case .requestLocation:
            getUserLocation()

        case .inputText(let text):
            filter(with: text)

        case .close:
            router.close()

        }
    }

}
