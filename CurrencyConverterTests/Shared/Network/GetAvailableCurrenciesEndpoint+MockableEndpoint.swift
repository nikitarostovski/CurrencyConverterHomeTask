//
//  GetAvailableCurrenciesEndpoint+MockableEndpoint.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
@testable import CurrencyConverter

extension GetAvailableCurrenciesEndpoint: MockableEndpoint {
    public func mockedResponse(for request: NetworkRequest, forceError: Bool) -> NetworkResponse {
        let resource = forceError ? "error.json" : path
        guard let url = Bundle.main.url(forResource: resource, withExtension: nil),
              let data = try? Data(contentsOf: url)
        else {
            return NetworkResponse(httpCode: 404, payload: nil)
        }
        
        return NetworkResponse(httpCode: 200, payload: data)
    }
}
