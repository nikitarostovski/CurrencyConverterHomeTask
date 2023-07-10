//
//  CurrencyServiceMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyServiceMock: CurrencyService {
    var delegate: CurrencyServiceDelegate? {
        didSet {
            delegate?.currencyServiceDidUpdateData()
        }
    }
    var selectedCurrency: CurrencyCode?
    var lastDataUpdateTime: Date?
    var exchangeDataCreationTime: Date?
    var retryAvailable: Bool = true
    
    var shouldFail = false
    var reloadCallCount = 0
    
    func triggerDelegateCall() {
        delegate?.currencyServiceDidUpdateData()
    }
    
    func convert(_ money: CurrencyConverter.Money) async -> Result<[Money], CurrencyServiceError> {
        if shouldFail {
            return .failure(.unableToGetData)
        }
        return .success([])
    }
    
    func getAvailableCurrencies() async -> Result<[CurrencyCode], CurrencyServiceError> {
        if shouldFail {
            return .failure(.unableToGetData)
        }
        return .success([""])
    }
    
    func getCurrencyName(_ code: CurrencyCode) -> String? {
        if shouldFail {
            return nil
        }
        return ""
    }
    
    func reloadDataIfAvailable() {
        reloadCallCount += 1
    }
    
    func clear() {
        reloadCallCount = 0
        shouldFail = false
    }
}
