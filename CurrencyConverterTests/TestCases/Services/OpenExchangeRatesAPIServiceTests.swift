//
//  OpenExchangeRatesAPIServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class OpenExchangeRatesAPIServiceTests: XCTestCase {
    var service: OpenExchangeRatesAPIService!
    var networkService: MockedNetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = MockedNetworkService(delay: .networkDelay)
        service = .init(networkService: networkService, appID: "")
    }
    
    func testAPIService_returnsCurrencyNames() async {
        let result = try? await service.getAvailableCurrencyNames()
        XCTAssertNotNil(result)
    }
    
    func testAPIService_returnsExchangeData() async {
        let result = try? await service.getExchangeData()
        XCTAssertNotNil(result)
    }
    
    func testAPIService_throwsOnNetworkServiceError() async {
        networkService.forceError = true
        var caughtError: Error?
        do {
            _ = try await service.getExchangeData()
        } catch {
            caughtError = error
        }
        XCTAssert(caughtError != nil)
    }
}
