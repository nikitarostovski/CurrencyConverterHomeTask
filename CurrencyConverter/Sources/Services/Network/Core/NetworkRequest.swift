//
//  NetworkRequest.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public struct NetworkRequest {
    public let endpoint: EndpointProviding
    public let httpMethod: HTTPMethod
    public let headers: [String: String]
    public let parameters: Data?
    
    public init(endpoint: EndpointProviding, headers: [String: String] = [:], parameters: Data? = nil) {
        self.endpoint = endpoint
        self.httpMethod = endpoint.method
        self.headers = headers
        self.parameters = parameters
    }
}
