//
//  DecimalFormattingTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class DecimalFormattingTests: XCTestCase {
    func testDecimalFormatting_resultHasSymbol() {
        let input: Decimal = 123.45
        let symbol = "C"
        let expectedResult = "C 123.45"
        
        let result = input.formattedCurrency(symbol)
        
        XCTAssertEqual(result, expectedResult)
    }
    
    func testDecimalFormatting_resultHasNoSymbol() {
        let input: Decimal = 123.45
        let expectedResult = "123.45"
        
        let result = input.formattedCurrency()
        
        XCTAssertEqual(result, expectedResult)
    }
}
