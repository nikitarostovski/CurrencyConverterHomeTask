//
//  EndpointProviding+Error.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

extension EndpointProviding {
    /// Tries to parse response as an `OpenExchangeRatesError` object
    /// - Parameters:
    ///   - response: network response to parse
    ///   - coder: coder for decoding
    /// - Returns: `OpenExchangeRatesError` or any other `EndpointError`
    public func processError(response: NetworkResponse, coder: APICoder) async -> EndpointError {
        guard let data = response.payload else { return CommonEndpointError.unknown }
            
        do {
            let errorModel = try await coder.decode(GeneralErrorDTO.self, data: data)
            return OpenExchangeRatesError(errorModel) ?? CommonEndpointError.unknown
        } catch {
            return CommonEndpointError.unknown
        }
    }
}
