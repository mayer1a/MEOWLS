//
//  Paginator.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import Foundation
import Factory

public final class Paginator: PaginatorProtocol {

    public var pageSize: Int

    private var current: Int?
    private var next: Int?
    private var paginationType: PaginationType = .unknown

    public required init(pageSize: Int) {
        self.pageSize = pageSize
    }

    public var hasNextPage: Bool {
        next != nil
    }

    public var isFirstPage: Bool {
        current ?? 0 < 2
    }

    public var nextParameters: [String: Any] {
        var parameters: [String: Any] = [PaginationInfo.CodingKeys.perPage.rawValue: pageSize]

        guard let next else {
            return parameters
        }

        switch paginationType {
        case .page:
            parameters[PaginationInfo.CodingKeys.page.rawValue] = next

        case .unknown:
            break

        }
        return parameters
    }

    public func pagination<D: Codable>(with response: PaginationResponse<D>) {
        if paginationType == .unknown {
            setPaginationType(response)
        }

        switch paginationType {
        case .page:
            current = response.paginationInfo.page
            next = response.paginationInfo.nextPage

        case .unknown:
            break

        }
    }

    public func reset() {
        current = nil
        next = nil
        paginationType = .unknown
    }

}

private extension Paginator {

    enum PaginationType {
        case page
        case unknown
    }

}

private extension Paginator {

    func setPaginationType<D: Codable>(_ response: PaginationResponse<D>) {
        if response.paginationInfo.nextPage != nil {
            paginationType = .page
        }
    }

}

// MARK: - Register container

public extension Container {

    var paginator: Factory<PaginatorProtocol> {
        self {
            Paginator(pageSize: 20)
        }
    }

}
