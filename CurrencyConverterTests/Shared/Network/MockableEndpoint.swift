//
//  MockableEndpoint.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation
@testable import CurrencyConverter

public protocol MockableEndpoint {
    func mockedResponse(for request: NetworkRequest, forceError: Bool) -> NetworkResponse
}
