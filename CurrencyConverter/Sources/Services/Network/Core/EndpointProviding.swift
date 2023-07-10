//
//  EndpointProviding.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public protocol EndpointError: Error { }

/// Common networking error
public enum CommonEndpointError: EndpointError {
    case unknown
    case emptyResponse
    case mappingFailed
}

/// Provides all necessary data for one single endpoint
public protocol EndpointProviding {
    var path: String { get }
    var method: HTTPMethod { get }
    var urlParams: [String: String] { get }
    
    func validate(response: NetworkResponse, coder: APICoder) async throws
}
