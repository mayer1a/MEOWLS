//
//  RegionModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 17.09.2024.
//

import Combine

public enum RegionModel {}

extension RegionModel {

    public struct InputModel {
        let cities: [City]
        let selectedCity: City?
        let selectedCityHandler: ((City?) -> Void)?
    }

    struct InitialModel {
        let inputModel: InputModel
        let router: RegionRouterProtocol
        let apiService: RegionApiServiceProtocol
        let regionAgent: RegionAgentProtocol
        let locationManager: LocationManagerProtocol
    }

    typealias Section = ItemsDataSource<Row>.Section<Row>

    enum Row: Item {
        case city(City, selected: Bool)
    }

    enum Route {
        struct LocationError {
            let message: String?
            let handler: VoidClosure?
        }
        case locationErrorDialog(model: LocationError)
        case confirmationRegionDialog(city: City?, handler: VoidClosure)
    }

    enum LoadingStatus {
        case start, stop
    }

}

extension RegionModel {

    struct BindingInput {
        let viewAction: PassthroughSubject<ViewAction, Never>
    }

    struct BindingOutput {
        let label: AnyPublisher<Label?, Never>
        let viewState: AnyPublisher<ViewState, Never>
    }

    enum Label {
        case showError(String?)
    }

    enum ViewState {
        case initial
        case loading(LoadingStatus)
        case fillingDataState(FillingDataState)

        struct FillingDataState {
            let items: [Section]
        }
    }

    enum ViewAction {
        case viewDidLoad
        case tapCell(Row)
        case requestLocation
        case inputText(String?)
        case close
    }

}
