//
//  APIServiceProtocol.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import Alamofire

public typealias ResponseHandler<D: Decodable> = (_ response: APIResponse<D>) -> Void
public typealias AFResponse = AFDataResponse<Data>

public protocol APIServiceProtocol: AnyObject {

    func url(from resource: APIResourcePath, service: APIResourceService) -> String

    @discardableResult
    func get<D>(resource: APIResourcePath,
                service: APIResourceService?,
                parameters: Parameters?,
                headers: HTTPHeaders?,
                handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable

    @discardableResult
    func post<D>(resource: APIResourcePath,
                 service: APIResourceService?,
                 parameters: Parameters?,
                 headers: HTTPHeaders?,
                 handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable

    @discardableResult
    func post<D>(resource: APIResourcePath,
                 service: APIResourceService?,
                 data: Data?,
                 headers: HTTPHeaders?,
                 handler: @escaping ResponseHandler<D>) -> DataRequest? where D: Decodable

}
