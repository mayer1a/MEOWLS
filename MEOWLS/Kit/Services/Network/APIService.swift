//
//  APIService.swift
//  MEOWLS
//
//  Created by Artem Mayer on 11.09.2024.
//

import Foundation
import Alamofire
import Factory

public class APIService: APIServiceProtocol {

    #if Store
        typealias User = UserAccess & UserRegion & UserAuthorization
    #else
        typealias User = UserAccess & UserRegion & UserEmployee
    #endif

    let server: APIResourceServer
    let user: User

    private static let contentType = "application/json"

    init(server: APIResourceServer, user: User) {
        self.server = server
        self.user = user
    }

    public func url(from resource: APIResourcePath, service: APIResourceService) -> String {
        service.baseUrl(server) + resource.description
    }

    @discardableResult
    public func get<D>(resource: APIResourcePath,
                       service: APIResourceService?,
                       parameters: Parameters?,
                       headers: HTTPHeaders?,
                       handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable {

        let service = service ?? .current
        let urlString = url(from: resource, service: service)
        var fullHeaders = self.headers(service)
        headers?.forEach({ fullHeaders.add($0) })

        return raw(method: .get, urlString: urlString, parameters: parameters, headers: fullHeaders, handler: handler)
    }

    @discardableResult
    public func post<D>(resource: APIResourcePath,
                        service: APIResourceService?,
                        parameters: Parameters?,
                        headers: HTTPHeaders?,
                        handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable {

        let service = service ?? .current
        let urlString  = url(from: resource, service: service)
        var fullHeaders = self.headers(service)
        headers?.forEach({ fullHeaders.add($0) })

        return raw(method: .post, urlString: urlString, parameters: parameters, headers: fullHeaders, handler: handler)
    }

    @discardableResult
    public func post<D>(resource: APIResourcePath,
                        service: APIResourceService?,
                        data: Data?,
                        headers: HTTPHeaders?,
                        handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable {

        let service = service ?? .current
        let urlString  = url(from: resource, service: service)
        var fullHeaders = self.headers(service)
        headers?.forEach({ fullHeaders.add($0) })

        return raw(method: .post, urlString: urlString, data: data, headers: fullHeaders, handler: handler)
    }

    private func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
        UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }

    private func endBackgroundTask(_ taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }

}

// MARK: - Basic

private extension APIService {

    func headers(_ service: APIResourceService) -> HTTPHeaders {
        var headers: HTTPHeaders = [.contentType(Self.contentType)]

        if let accessToken = user.accessToken(service) {
            headers.add(.authorization(accessToken))
        }

        if let region = user.currentRegion?.id {
            headers.add(name: "X-City-Id", value: region)
        }

        headers.add(name: "X-Device-Manufacturer", value: "Apple")
        headers.add(name: "X-Platform", value: UIDevice.current.systemName.lowercased())
        headers.add(name: "X-OS-Version", value: UIDevice.current.systemVersion)
        headers.add(name: "X-Device-Model", value: UIDevice.modelName)
        headers.add(name: "X-Device-Brand", value: UIDevice.current.model)
        headers.add(name: "X-Platform", value: UIDevice.current.systemName.lowercased())

        if let dictionary = Bundle.main.infoDictionary,
           let version = dictionary["CFBundleShortVersionString"] as? String,
           let build = dictionary["CFBundleVersion"] as? String {

            // "1.1.11"
            headers.add(name: "X-App-Version", value: version)
            // "1"
            headers.add(name: "X-App-Version-Code", value: build)
        }

        return headers
    }

    func raw<D>(method: HTTPMethod,
                urlString url: String,
                parameters: Parameters? = nil,
                headers: HTTPHeaders,
                handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable {

        let encoding: ParameterEncoding
        if method == .get {
            encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .literal)
        } else {
            encoding = JSONEncoding.default
        }
        let task = beginBackgroundTask()

        return AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseData { [weak self] response in
                guard let self else { return }

                self.handleResponseData(response, handler: handler)
                self.endBackgroundTask(task)
            }
    }

    func raw<D>(method: HTTPMethod,
                urlString: String,
                data: Data? = nil,
                headers: HTTPHeaders,
                handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable {

        guard let url = urlString.toURL else {
            handler(APIResponse(error: "Wrong url"))
            return nil
        }

        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        request.headers.update(.contentType(Self.contentType))
        request.httpBody = data

        let task = beginBackgroundTask()

        return AF.request(request)
            .validate()
            .responseData { [weak self] (response) in
                guard let self else { return }

                self.handleResponseData(response, handler: handler)
                self.endBackgroundTask(task)
            }
    }

}

// MARK: - Handlers

private extension APIService {

    func handleResponseRawData<D: Decodable>(_ data: Data, code: Int?, handler: @escaping ResponseHandler<D>) {
        guard !data.isEmpty else {
            handler(APIResponse(code: code))
            return
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(parseDate)

        do {
            let decoded = try decoder.decode(D.self, from: data)
            handler(APIResponse(data: decoded, code: code))
        } catch let error {
            handler(APIResponse(error: error.localizedDescription, code: code))
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            print("JSON decoding localized error to \(D.self) - \(error.localizedDescription)")
            print("RAW: \(jsonDictionary ?? "Unable to get raw JSON")")
            print("Unlocalized error \(error)")
        }
    }

    func handleResponseData<D: Decodable>(_ response: AFResponse, handler: @escaping ResponseHandler<D>) {
        switch response.result {
        case .success(let data):
            handleResponseRawData(data, code: response.response?.statusCode, handler: handler)

        case .failure(let error):
            var errorMessage: String? = nil
            var errorCode: String?

            if let data = response.data, let error = try? JSONDecoder().decode(ResponseError.self, from: data) {
                errorCode = error.code
                errorMessage = APIErrorLocalizer.localizeError(code: error.code, message: error.reason)
            } else {
                errorMessage = error.localizedDescription
            }

            let statusCode = response.response?.statusCode
            // If the token is expired, we send the user for re-authorization
            let nonAuthError = errorCode != APIErrorLocalizer.ErrorCode.authError.rawValue
            let refreshPath = APIResourcePath.refreshToken.description
            let isRefreshingProduced = response.request?.url?.absoluteString.contains(refreshPath) ?? false

            if statusCode == 401, nonAuthError, !isRefreshingProduced {
                #if Store

                refreshToken(message: errorMessage, response: response, handler: handler)

                #endif
                return
            }

            handler(APIResponse(error: errorMessage, code: statusCode, dataResponse: response))
        }
    }

    func refreshToken<D: Decodable>(message: String?, response: AFResponse, handler: @escaping ResponseHandler<D>) {
        user.refreshToken(isSilent: user.tokenExpired) { error in
            DispatchQueue.main.async { [weak self, response, handler, error] in
                guard
                    let self,
                    error != nil,
                    let method = response.request?.method,
                    let url = response.request?.url?.absoluteString,
                    let headers = response.request?.headers,
                    let body = response.request?.httpBody
                else {
                    handler(APIResponse(error: message, code: response.response?.statusCode, dataResponse: response))
                    return
                }

                _ = raw(method: method, urlString: url, data: body, headers: headers, handler: handler)
            }
        }
    }

    func parseDate(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_US")
        let dateFormats = ["yyyy-MM-dd", "dd.MM.yyyy", "yyyy-MM-dd'T'HH:mm:ssZ", "dd.MM.yyyy'T'HH:mm:ssZ"]

        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
    }

}

// MARK: - Register container

extension Container {

    public var apiService: Factory<APIServiceProtocol> {
        self {
            APIService(server: .production, user: resolve(\.user))
        }
        .onDebug {
            APIService(server: .development, user: resolve(\.user))
        }
        .singleton
    }

}
