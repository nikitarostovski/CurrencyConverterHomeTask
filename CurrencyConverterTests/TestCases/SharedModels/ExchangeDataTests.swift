//
//  ExchangeDataTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class ExchangeDataTests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testExchangeDataConvertFromBase_resultCountEqualsCurrenciesCount() {
        let base = CurrencyCode(code: "USD")!
        let codes = ["JPY", "THB", "RUB"]
        let inputMoney = Money(amount: 0, currencyCode: base, currencyName: nil)
        let rates = codes.map { Rate(baseCode: base, currencyCode: $0, rate: 0) }
        let exchangeData = ExchangeData(timestamp: Date(), baseCode: base, rates: rates)
        let expectedCount = codes.count
        
        let result = exchangeData.convert(inputMoney)
        
        XCTAssertEqual(result.count, expectedCount)
    }
    
    func testExchangeDataConvertFromNotBase_resultCountEqualsCurrenciesCount() {
        let base = CurrencyCode(code: "USD")!
        let codes = ["JPY", "THB", "RUB"]
        let inputMoney = Money(amount: 0, currencyCode: base, currencyName: nil)
        let rates = codes.map { Rate(baseCode: base, currencyCode: $0, rate: 0) }
        let exchangeData = ExchangeData(timestamp: Date(), baseCode: codes[0], rates: rates)
        let expectedCount = codes.count
        
        let result = exchangeData.convert(inputMoney)
        
        XCTAssertEqual(result.count, expectedCount)
    }
    
    func testExchangeData_notReturningSameCurrency() {
        let base = CurrencyCode(code: "USD")!
        let codes = ["JPY"]
        let inputMoney = Money(amount: 0, currencyCode: base, currencyName: nil)
        let rates = codes.map { Rate(baseCode: base, currencyCode: $0, rate: 0) }
        let exchangeData = ExchangeData(timestamp: Date(), baseCode: codes[0], rates: rates)
        
        let result = exchangeData.convert(inputMoney)
        let hasInputCurrency = result.contains(where: { $0.currencyCode == inputMoney.currencyCode })
        
        XCTAssertFalse(hasInputCurrency)
    }
    
    func testExchangeData_amountToBaseConversion() {
        let base = CurrencyCode(code: "USD")!
        let targetCode = CurrencyCode(code: "RUB")!
        let rate: Decimal = 2
        let amount: Decimal = 10
        let rateModel = Rate(baseCode: base, currencyCode: targetCode, rate: rate)
        let exchangeData = ExchangeData(timestamp: Date(), baseCode: base, rates: [rateModel])
        let inputMoney = Money(amount: amount, currencyCode: targetCode, currencyName: nil)
        let result = exchangeData.convert(inputMoney)
        let expectedAmount: Decimal = 5
        
        XCTAssert(result.count > 0)
        XCTAssertEqual(result[0].amount, expectedAmount)
    }
}
