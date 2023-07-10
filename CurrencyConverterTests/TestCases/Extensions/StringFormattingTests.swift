//
//  StringFormattingTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class StringFormattingTests: XCTestCase {
    func testString_trimmedAmountIsValid() {
        let inputValue = "1a2.0-6,"
        let expectedResult = "12.06"
        
        let result = inputValue.trimmedAmount
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testString_amountIsValid() {
        let inputValue = "123.45"
        let expectedResult: Decimal = 123.45
        
        let result = inputValue.amount
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testString_removesLeadingZeroes() {
        let values = [
            "000123": "123",
            "-012": "-12",
            "0.45": "0.45",
            "000.1": "0.1",
            "-00.1": "-0.1"
        ]
        
        values.forEach {
            let result = $0.key.removingLeadingZeros()
            XCTAssertEqual(result, $0.value)
        }
    }
    
    func testString_removesTrailingSpaces() {
        let values = [
            "123 ": "123",
            "   ": "",
            " 1 ": " 1"
        ]
        
        values.forEach {
            let result = $0.key.removingTrailingSpaces()
            XCTAssertEqual(result, $0.value)
        }
    }
    
    func testString_returnsSymbolForCurrencyCode() {
        let locale = Locale(identifier: "en_US")
        let code = "USD"
        let expectedSymbol = "$"
        
        let result = String.currencySymbol(for: code, in: locale)
        
        XCTAssertEqual(result, expectedSymbol)
    }
}
