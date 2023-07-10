//
//  MockedNetworkService.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation
@testable import CurrencyConverter

public final class MockedNetworkService: NetworkService {
    public var delay: TimeInterval = 0
    public var forceError = false
    
    public init(delay: TimeInterval? = nil) {
        self.delay = delay ?? self.delay
    }
    
    public func request(_ request: NetworkRequest) async throws -> NetworkResponse {
        guard let endpoint = request.endpoint as? MockableEndpoint else {
            return NetworkResponse(httpCode: 404, payload: nil)
        }
        
        let response = endpoint.mockedResponse(for: request, forceError: forceError)
        
        if delay <= 0 {
            return response
        }

        let handle = Task { () -> NetworkResponse in
            try await Task.sleep(seconds: delay)
            return response
        }
        
        return try await handle.value
    }
}

fileprivate extension Task {
    static func sleep(seconds: TimeInterval) async throws where Success == Never, Failure == Never {
        try await sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
