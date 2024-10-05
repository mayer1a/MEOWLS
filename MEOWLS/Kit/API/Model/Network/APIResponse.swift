//
//  APIResponse.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import Foundation
import Alamofire

public struct APIResponse<D: Decodable> {

    public let data: D?
    public let error: String?
    public let code: Int?
    public let dataResponse: AFResponse?

    init(data: D? = nil, error: String? = nil, code: Int? = nil, dataResponse: AFResponse? = nil) {
        self.data = data
        self.error = error
        self.code = code
        self.dataResponse = dataResponse
    }

}

extension APIResponse {

    init(from response: AFResponse) {
        self.dataResponse = response
        self.code = response.response?.statusCode

        if let responseData = response.data {
            do {
                self.data = try JSONDecoder().decode(D.self, from: responseData)
                self.error = nil
            } catch {
                self.data = nil
                self.error = error.localizedDescription
            }
        } else {
            self.data = nil
            self.error = response.error?.localizedDescription
        }
    }

}
