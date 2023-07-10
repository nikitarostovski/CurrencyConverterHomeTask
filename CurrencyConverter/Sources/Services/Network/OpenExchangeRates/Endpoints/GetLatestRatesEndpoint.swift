//
//  GetLatestRatesEndpoint.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public struct GetLatestRatesEndpoint: EndpointProviding {
    public let path: String
    public let method: HTTPMethod = .get
    public var urlParams: [String: String]
    
    public init(base: String?) {
        if let base = base {
            self.urlParams = ["base": base]
        } else {
            self.urlParams = [:]
        }
        self.path = "latest.json"
    }
    
    public func validate(response: NetworkResponse, coder: APICoder) async throws {
        guard let code = response.httpCode else { throw CommonEndpointError.unknown }
        
        let error: EndpointError?
        switch (code, response.payload) {
        case (200, .some): error = nil
        case (200, .none): error = CommonEndpointError.emptyResponse
        default: error = await processError(response: response, coder: coder)
        }
        
        try error.map { throw $0 }
    }
}
