//
//  APIErrorLocalizer.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import Foundation

/// Localizes error messages coming from the server
/// Only needed for those errors that need to be shown to the user
final class APIErrorLocalizer {

    private static let baseLocalization = "NetworkError"

    static func localizeError(code: String, message: String) -> String {
        if let result = handleErrorCode(code, message: message) {
            return result
        } else if code == ErrorCode.internalServerError.rawValue {
            return "\(APIErrorLocalizer.baseLocalization).\(ErrorCode.internalApplicationError)".localized()
        } else {
            return message
        }
    }

    private static func handleErrorCode(_ code: String, message: String) -> String? {
        guard let error = ErrorCode(rawValue: code) else {
            return nil
        }

        let localizedError = "\(APIErrorLocalizer.baseLocalization).\(code)".localizedFormat()
        if error == .abortError {
            return String(format: localizedError, message)
        }

        return localizedError
    }

}


extension APIErrorLocalizer {

    enum ErrorCode: String {
        case productUnavailable
        case oneProductUnavailable
        case productAlreadyStarred
        case orderAlreadyCancelled
        case orderIsComplete
        case itemsNotAvailableWithSetCount
        case deliveryCreationFailed
        case deliveryTimeIntervalNotAvailable
        case cityNotFoundById
        case invalidReceivedAddress
        case invalidOrderNumber
        case phoneAlreadyUsed
        case incorrectAddressNotFound
        case addressNotFound
        case phoneRequired
        case invalidEmailFormat
        case invalidPasswordFormat
        case passwordsDidNotMatch
        case saleNotFound
        case userCartUnavailable
        case failedToFindUserCart
        case failedToFindProductPrice
        case productVariantNotFound
        case fetchCategoryError
        case fetchProductsForCategoryError
        case fetchProductsForSaleError
        case fetchProductByIdError
        case fetchFiltersForCategoryError
        case bannerCategoriesError
        case bannerProductsPriceError
        case bannerProductsAvailabilityError
        case fetchFavoritesError
        case orderCreationFailed
        case totalSummaryNotFound
        case deliveryNotFoundForOrder
        case abortError
        case authError
        case validationError
        case serviceUnavailable
        case unauthorized
        case internalServerError, internalApplicationError
    }

}
