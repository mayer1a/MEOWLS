//
//  Strings.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

public final class Strings {

    public enum Common {
        public enum List {
            public static let isEmpty = "Common.List.isEmpty".localized()
        }
        public enum LoadMore {
            public static let failed = "Common.LoadMore.failed".localized()
            public static let tryagain = "Common.LoadMore.tryagain".localized()
        }
        public enum FailedRequestView {
            public static let title = "Common.FailedRequestView.title".localizedFormat()
            public static let button = "Common.FailedRequestView.button".localizedFormat()
        }
        public enum AnotherRegionRequestView {
            public static let title = "Common.AnotherRegionView.title".localizedFormat()
            public static let button = "Common.AnotherRegionView.button".localizedFormat()
        }
        public enum Authorization {
            public enum Agreement {
                public static let start = "Common.Authorization.Agreement.start".localized()
                public static let privacy = "Common.Authorization.Agreement.privacy".localized()
                public static let end = "Common.Authorization.Agreement.end".localized()
                public static let userAgreement = "Common.Authorization.Agreement.userAgreement".localized()
            }
            public static let incorrectNumberError = "Common.Authorization.incorrectNumberError".localized()
            public static let login = "Common.Authorization.login".localized()
        }
        public enum Registration {
            public static let digit = "Common.Registration.digit".localized()
            public static let email = "Common.Registration.email".localized()
            public static let lowercase = "Common.Registration.lowercase".localized()
            public static let passwordDidNotMatch = "Common.Registration.passwordDidNotMatch".localized()
            public static let passwordLength = "Common.Registration.passwordLength".localized()
            public static let upperCase = "Common.Registration.upperCase".localized()
        }
        public enum System {
            public static let underConstructionTitle = "Common.System.underConstructionTitle".localized()
            public static let underConstructionTitleApp = "Common.System.underConstructionTitleApp".localized()
            public static let underConstructionTitleScreen = "Common.System.underConstructionTitleScreen".localized()
        }
        public static let systemOptions = "Common.systemOptions".localized()
        public static let cancel = "Common.cancel".localized()
        public static let contiue = "Common.contiue".localized()
        public static let phone = "Common.Authorization.phone".localized()
        public static let skip = "Common.Authorization.skip".localized()
    }
    public enum RootTabBar {
        public static let main = "RootTabBar.main".localized()
        public static let catalogue = "RootTabBar.catalogue".localized()
        public static let cart = "Cart.title".localized()
        public static let favorites = "Favorites.title".localized()
        public static let profile = "RootTabBar.profile".localized()
        public static let tasks = "RootTabBar.tasks".localized()
    }
    public enum Main {
        public static let search = "Main.search".localized()
        public static let promotionDoesntExist = "Main.promotionDoesntExist".localized()
        public static let categoryDoesntExist = "Main.categoryDoesntExist".localized()
    }
    public enum Catalogue {
        public static let toCart = "Catalogue.addToCart".localized()
        public static let inCart = "Catalogue.inCart".localized()
        public enum Product {
            public static let priceFrom = "Catalogue.Product.priceFrom".localizedFormat()
        }
        public enum Filters {
            public static let done = "Catalogue.Filters.done".localized()
        }
        public enum Searching {
            public static let title = "Catalogue.Searching.title".localized()
            public static let noResultsHeader = "Catalogue.Searching.noResultsHeader".localized()
            public static let noResultDetails = "Catalogue.Searching.noResultDetails".localized()
            public static let findGood = "Catalogue.Searching.findGood".localized()
            public static let findGoods = "Catalogue.Searching.findGoods".localized()
            public static let itemsCount = "Catalogue.Searching.itemsCount".localizedFormat()
            public static let showAll = "Catalogue.Searching.showAll".localized()
        }
        public enum Categories {
            public static let all = "Catalogue.Categories.all".localized()
        }
    }
    public enum Favorites {
        public static let title = "Favorites.title".localized()
        public static let authorizedMessage = "Favorites.authorizedMessage".localized()
        public static let authorizedDescription = "Favorites.authorizedDescription".localized()
        public static let unauthorizedMessage = "Favorites.unauthorizedMessage".localized()
        public static let unauthorizedDescription = "Favorites.unauthorizedDescription".localized()
    }
    public enum Cart {
        public enum Payment {
            public static let bankCardTitle = "Cart.Payment.bankCardTitle".localized()
            public static let cashTitle = "Cart.Payment.cashTitle".localized()
            public static let paySubtitle = "Cart.Payment.paySubtitle".localized()
            public static let promocode = "Cart.Payment.promocode".localized()
            public static let totalPrice = "Cart.Payment.totalPrice".localized()
            public static let discount = "Cart.Payment.discount".localized()
            public static let itemsWithoutDiscount = "Cart.Payment.itemsWithoutDiscount".localized()
        }
        public enum Delivery {
            public static let delivery = "Cart.Delivery.delivery".localized()
        }
        public enum Order {
            public enum Status {
                public static let new = "Cart.Order.Status.new".localized()
                public static let inProgress = "Cart.Order.Status.inProgress".localized()
                public static let completed = "Cart.Order.Status.completed".localized()
                public static let canceled = "Cart.Order.Status.canceled".localized()
            }
        }
        public enum Empty {
            public static let unauthorizedAction = "Cart.Empty.unauthorizedAction".localized()
        }
    }
    public enum Profile {
        public enum UserProfile {
            public static let title = "Profile.UserProfile.title".localized()
            public static let guest = "Profile.UserProfile.guest".localized()
            public static let emptyname = "Profile.UserProfile.emptyname".localized()
            public static let qrTitle = "Profile.UserProfile.qrTitle".localized()

            public static let deleteAccountAlertTitle = "Profile.UserProfile.deleteAccountAlertTitle".localized()
            public static let deleteAccountAlertMessage = "Profile.UserProfile.deleteAccountAlertMessage".localized()

            public static let pushWarningAlertTitle = "Profile.UserProfile.pushWarningAlertTitle".localized()
            public static let pushWarningAlertMessage = "Profile.UserProfile.pushWarningAlertMessage".localized()
        }
        public enum Edit {
            public static let title = "Profile.Edit.title".localized()
            public static let woman = "Profile.Edit.female".localized()
            public static let man = "Profile.Edit.male".localized()
            public static let birthday = "Profile.Edit.birthday".localized()
            public static let birthdayImmutable = "Profile.Edit.birthdayImmutable".localized()
            public static let phone = "Profile.Edit.phone".localized()
            public static let phoneImmutable = "Profile.Edit.phoneImmutable".localized()
        }
        public enum Logout {
            public static let errorTitle = "Profile.Logout.errorTitle".localized()
            public static let errorSubtitle = "Profile.Logout.errorSubtitle".localized()
            public static let errorRepeat = "Profile.Logout.errorRepeat".localized()
            public static let errorNetwork = "Profile.Logout.errorNetwork".localized()
            public static let logout = "Profile.Logout.logout".localized()

            public static let logoutAlertTitle = "Profile.Logout.logoutAlertTitle".localized()
            public static let logoutAlertMessage = "Profile.Logout.logoutAlertMessage".localized()
        }
    }
    public enum Promotion {
        public static let fromto = "Promotion.fromto".localized()
        public static let from = "Promotion.from".localized()
        public static let to = "Promotion.to".localized()
        public static let until = "Promotion.until".localized()
        public static let title = "Promotion.title".localized()
        public static let abouttitle = "Promotion.abouttitle".localized()
        public static let periodTitle = "Promotion.periodTitle".localized()
        public static let descriptionTitle = "Promotion.descriptionTitle".localized()
        public static let productsTitle = "Promotion.productsTitle".localized()
        public static let promoUsed = "Promotion.promoUsed".localized()
        public static let showAll = "Promotion.showAll".localized()
        public static let activeIn = "Promotion.activeIn".localized()
        public static let emptyWarning = "Promotion.emptyWarning".localized()
        public static let actionsPreface = "Promotion.actionsPreface".localized()
        public static let unauthorizedPromocodeDisclaimer = "Promotion.unauthorizedPromocodeDisclaimer".localized()
        public static let activatePromocodeTitle = "Promotion.activatePromocodeTitle".localized()
        public static let authorizeActivatePromocodeTitle = "Promotion.authorizeActivatePromocodeTitle".localized()
        public static let promocode = "Promotion.promocode".localized()
        public static let showPromocode = "Promotion.showPromocode".localized()
        public static let isUsed = "Promotion.isUsed".localized()
        public static let isExpired = "Promotion.isExpired".localized()

        public enum Cell {
            public static let promoCopied = "Promotion.Cell.promoCopied".localized()
            public static let noPromo = "Promotion.Cell.noPromo".localized()
            public static let promoErrorRetry = "Promotion.Cell.promoErrorRetry".localized()
            public static let cantUsePromo = "Promotion.Cell.cantUsePromo".localized()
        }
    }
    public enum Region {
        public enum Request {
            public static let title = "Region.Request.title".localized()
            public static let no = "Region.Request.no".localized()
            public static let yes = "Region.Request.yes".localized()
            public static let isCorrect = "Region.Request.isCorrect".localized()
        }
        public enum Default {
            public static let region = "Region.Default.region".localized()
        }
        public enum Choose {
            public static let title = "Region.Choose.title".localized()
            public static let search = "Region.Choose.search".localized()
            public static let yourCity = "Region.Choose.yourCity".localized()
        }
        public enum Warning {
            public static let required = "Region.Warning.required".localized()
            public static let undefined = "Region.Warning.undefined".localized()
        }
    }
    public enum SingleLocation {
        public static let authorizedAlways = "SingleLocation.authorizedAlways".localized()
        public static let authorizedWhenInUse = "SingleLocation.authorizedWhenInUse".localized()
        public static let denied = "SingleLocation.denied".localized()
        public static let notDetermined = "SingleLocation.notDetermined".localized()
        public static let restricted = "SingleLocation.restricted".localized()
        public static let unknown = "SingleLocation.unknown".localized()
    }
    public enum Alert {
        public enum NetworkError {
            public static let title = "Alert.NetworkError.title".localized()
            public static let message = "Alert.NetworkError.message".localized()
            public static let `repeat` = "Alert.NetworkError.repeat".localized()
            public static let cancel = "Alert.NetworkError.cancel".localized()
            public static let unauthorized = "NetworkError.unauthorized".localized()
        }
        public enum Warning {
            public static let attention = "Alert.Warning.attention".localized()
        }
        public enum Delete {
            public static let destructive = "Alert.Delete.destructive".localized()
            public static let cancel = "Alert.Delete.cancel".localized()
            public static let cartItem = "Alert.Delete.cartItem".localized()
        }
        public enum Common {
            public static let yes = "Alert.common.yes".localized()
            public static let no = "Alert.common.no".localized()
            public static let cancel = "Alert.common.cancel".localized()
            public static let ok = "Alert.common.ok".localized()
            public static let error = "Alert.common.error".localized()
            public static let `repeat` =  "Alert.common.repeat".localized()
            public static let message = "Alert.common.message".localized()
        }
    }
    public enum NetworkError {
        public static let productUnavailable = "NetworkError.productUnavailable".localized()
        public static let oneProductUnavailable = "NetworkError.oneProductUnavailable".localized()
        public static let productAlreadyStarred = "NetworkError.productAlreadyStarred".localized()
        public static let orderAlreadyCancelled = "NetworkError.orderAlreadyCancelled".localized()
        public static let orderIsComplete = "NetworkError.orderIsComplete".localized()
        public static let itemsNotAvailableWithSetCount = "NetworkError.itemsNotAvailableWithSetCount".localized()
        public static let deliveryCreationFailed = "NetworkError.deliveryCreationFailed".localized()
        public static let deliveryTimeIntervalNotAvailable = "NetworkError.deliveryTimeIntervalNotAvailable".localized()
        public static let cityNotFoundById = "NetworkError.cityNotFoundById".localized()
        public static let invalidReceivedAddress = "NetworkError.invalidReceivedAddress".localized()
        public static let invalidOrderNumber = "NetworkError.invalidOrderNumber".localized()
        public static let phoneAlreadyUsed = "NetworkError.phoneAlreadyUsed".localized()
        public static let incorrectAddressNotFound = "NetworkError.incorrectAddressNotFound".localized()
        public static let addressNotFound = "NetworkError.addressNotFound".localized()
        public static let phoneRequired = "NetworkError.phoneRequired".localized()
        public static let invalidEmailFormat = "NetworkError.invalidEmailFormat".localized()
        public static let invalidPasswordFormat = "NetworkError.invalidPasswordFormat".localized()
        public static let passwordsDidNotMatch = "NetworkError.passwordsDidNotMatch".localized()
        public static let saleNotFound = "NetworkError.saleNotFound".localized()

        public static let userCartUnavailable = "NetworkError.userCartUnavailable".localized()
        public static let failedToFindUserCart = "NetworkError.failedToFindUserCart".localized()
        public static let failedToFindProductPrice = "NetworkError.failedToFindProductPrice".localized()
        public static let productVariantNotFound = "NetworkError.productVariantNotFound".localized()
        public static let fetchCategoryError = "NetworkError.fetchCategoryError".localized()
        public static let fetchProductsForCategoryError = "NetworkError.fetchProductsForCategoryError".localized()
        public static let fetchProductsForSaleError = "NetworkError.fetchProductsForSaleError".localized()
        public static let fetchProductByIdError = "NetworkError.fetchProductByIdError".localized()
        public static let fetchFiltersForCategoryError = "NetworkError.fetchFiltersForCategoryError".localized()
        public static let bannerCategoriesError = "NetworkError.bannerCategoriesError".localized()
        public static let bannerProductsPriceError = "NetworkError.bannerProductsPriceError".localized()
        public static let bannerProductsAvailabilityError = "NetworkError.bannerProductsAvailabilityError".localized()
        public static let fetchFavoritesError = "NetworkError.fetchFavoritesError".localized()
        public static let orderCreationFailed = "NetworkError.orderCreationFailed".localized()
        public static let totalSummaryNotFound = "NetworkError.totalSummaryNotFound".localized()
        public static let deliveryNotFoundForOrder = "NetworkError.deliveryNotFoundForOrder".localized()
    }

    public static func nofItems(_ item: String, _ number: Int) -> String {
        let idx = number%10
        let items = "\(number) \(item)"
        let teens = 11..<20

        switch idx {
        case 1:
            return teens.contains(number) ? "\(items)ов" : items

        case 2, 3, 4:
            return teens.contains(number) ? "\(items)ов" : "\(items)а"

        default:
            return "\(items)ов"

        }
    }

}
