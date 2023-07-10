//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public protocol NetworkService: AnyObject {
    func request(_ request: NetworkRequest) async throws -> NetworkResponse
    func request<Output: Decodable>(endpoint: EndpointProviding, coder: APICoder) async throws -> Output?
}

public extension NetworkService {
    func request<Output: Decodable>(endpoint: EndpointProviding, coder: APICoder) async throws -> Output? {
        guard let payload = try await performRequest(to: endpoint, coder: coder) else { return nil }
        try Task.checkCancellation()
        return try await coder.decode(Output.self, data: payload)
    }
    
    @discardableResult
    private func performRequest(to endpoint: EndpointProviding, encodedParameters: Data? = nil, coder: APICoder) async throws -> Data? {
        let request = NetworkRequest(endpoint: endpoint, parameters: encodedParameters)
        let response = try await self.request(request)
        try Task.checkCancellation()
        try await endpoint.validate(response: response, coder: coder)
        return response.payload
    }
}
