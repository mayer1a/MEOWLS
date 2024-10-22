//
//  MainModel.swift
//  MEOWLS
//
//  Created Artem Mayer on 02.10.2024.
//

import UIKit
import Combine

public enum MainModel {}

extension MainModel {

    public struct InputModel {}

    struct InitialModel {
        let inputModel: InputModel
        let router: MainRouterProtocol
        let apiService: MainApiServiceProtocol
        let favoritesService: FavoritesServiceProtocol
    }

    public typealias Section = ItemsDataSource<MainModel.Row>.Section<MainModel.Row>

    public enum Row: Item {
        case header(DomainHeaderWithButtonTableCell.ViewModel)
        case slider(SliderModel)
        case productsSlider(SliderModel)
        case tagsSlider(SliderModel)
        case verticalBanners(VerticalModel)

        public struct SliderModel {
            public let cellModel: BannerHorizontalCollectionCell.ViewModel
            public let bannerID: String
        }

        public struct VerticalModel {
            public let cellModel: BannerVerticalCollectionCell.ViewModel
            public let bannerID: String
        }
    }

    enum Route {
        case search
        case product(_ product: Product)
        case productsSet(_ query: String, _ title: String)
        case category(_ category: Category)
        case webView(URL)
        case sale(_ sale: Sale)
        case pushSubscriptionDialog
    }

}

extension MainModel {

    public struct BindingInput {
        let viewAction: PassthroughSubject<ViewAction, Never>
    }

    public struct BindingOutput {
        let label: AnyPublisher<Label?, Never>
        let viewState: AnyPublisher<ViewState, Never>
    }

    public enum Label {
        case showError(_ errorType: LoadingErrorType)
    }

    public enum LoadingErrorType {
        case banners(_ message: String?)
        case sale(_ message: String?, _ saleID: String)
    }

    public enum ViewState {
        case initial(DomainSearchBar.ViewModel?)
        case loading(LoadingStatus)
        case fillingDataState(FillingDataState)

        public struct FillingDataState {
            public let items: [Section]
        }
    }

    public enum ViewAction {
        case viewDidLoad(_ size: CGSize)
        case triggerRefresh(_ errorType: LoadingErrorType)
        case close
    }

    public enum LoadingStatus {
        case startLoading, stopLoading
    }

}

public extension MainModel {

    enum Constants {

        static let commonInsets = UIEdgeInsets(top: 4, left: horizontalInset, bottom: 24, right: horizontalInset)

        private static let horizontalInset: CGFloat = 16.0

        enum DomainHeader {
            static let inset = UIEdgeInsets(top: 16.0, left: horizontalInset, bottom: 12.0, right: horizontalInset)
            static let height: CGFloat = 36.0
        }

        enum Slider {
            static let spacing: CGFloat = 12.0
            /// To calculate the banner size relative to the screen
            static let itemInset = UIEdgeInsets(top: 0.0, left: 28.0, bottom: 0.0, right: 28.0)
            static let autoSlidingTimeout: Double = 5000

            static func inset(for spacings: MainBanner.UISettings.Spacing?) -> UIEdgeInsets {
                guard let spacings else {
                    return commonInsets
                }
                let top = spacings.top.toCGFloat
                let bottom = spacings.bottom.toCGFloat
                return UIEdgeInsets(top: top, left: horizontalInset, bottom: bottom, right: horizontalInset)
            }

            static func autoSlidingTimeout(for settings: MainBanner.UISettings?) -> Double {
                guard let timeout = settings?.autoSlidingTimeout?.toDouble, timeout != 0 else {
                    return autoSlidingTimeout
                }
                return timeout
            }
        }

        enum ProductsSlider {
            static let itemWidth: CGFloat = 180.0
        }

        enum VerticalBanners {
            static let horizontalSpacing: CGFloat = 12.0
            static let verticalSpacing: CGFloat = 12.0
            // width / height
            static let multipleItemsRatio: CGFloat = 343.0 / 177.0
            static let singleItemRatio: CGFloat = 343.0 / 200.0
        }

        enum Tags {
            static let spacing: CGFloat = 8.0
            static let estimatedItemWidth: CGFloat = 100.0
            static let itemHeight: CGFloat = 48.0
            static let imageWidth: CGFloat = 24.0

            static func inset(for spacings: MainBanner.UISettings.Spacing?) -> UIEdgeInsets {
                guard let spacings else {
                    return commonInsets
                }
                let top = spacings.top.toCGFloat
                let bottom = spacings.bottom.toCGFloat
                return UIEdgeInsets(top: top, left: horizontalInset, bottom: bottom, right: horizontalInset)
            }
        }

    }

}
