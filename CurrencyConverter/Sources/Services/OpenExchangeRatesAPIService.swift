//
//  OpenExchangeRatesAPIService.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

/// Service for network access to `openexchangerates.org`
final class OpenExchangeRatesAPIService {
    private let networkService: NetworkService
    private let coder = JSONAPICoder()
    private let defaultURLParams: [String: String]
    
    init(networkService: NetworkService, appID: String) {
        self.networkService = networkService
        self.defaultURLParams = ["app_id": appID]
    }
    
    /// Tries to request available currency codes and names
    /// - Returns: dictionary with currency codes and names. Key is code, Value is name
    func getAvailableCurrencyNames() async throws -> [CurrencyCode: String] {
        var endpoint = GetAvailableCurrenciesEndpoint()
        endpoint.urlParams = endpoint.urlParams.merging(defaultURLParams, uniquingKeysWith: { _, s in s })
        let dto: AvailableCurrenciesDTO? = try await networkService.request(endpoint: endpoint, coder: coder)
        guard let dto = dto else { throw CommonEndpointError.mappingFailed }
        
        return dto
    }
    
    /// Tries to request exchange rates data
    /// - Returns: `ExchangeData` object
    func getExchangeData() async throws -> ExchangeData {
        var endpoint = GetLatestRatesEndpoint(base: nil)
        endpoint.urlParams = endpoint.urlParams.merging(defaultURLParams, uniquingKeysWith: { _, s in s })
        let dto: LatestRatesDTO? = try await networkService.request(endpoint: endpoint, coder: coder)
        guard let dto = dto else { throw CommonEndpointError.mappingFailed }
        
        let rates: [Rate] = dto.rates.compactMap { codeString, rate -> Rate? in
            guard let code = CurrencyCode(code: codeString) else { return nil }
            return Rate(baseCode: dto.base, currencyCode: code, currencyName: nil, rate: rate)
        }
        return ExchangeData(createDate: Date(), timestamp: dto.timestamp, baseCode: dto.base, rates: rates)
    }
}
