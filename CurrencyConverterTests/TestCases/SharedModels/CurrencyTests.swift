//
//  CurrencyTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyTests: XCTestCase {
    func testCurrency_validation() {
        let validCodes = ["USD", "AAA", "zzz"]
        let invalidCodes = ["", " ", "A", "AA", "-AAA", "111"]
        
        validCodes.forEach {
            let code = CurrencyCode(code: $0)
            XCTAssertNotNil(code)
        }
        
        invalidCodes.forEach {
            let code = CurrencyCode(code: $0)
            XCTAssertNil(code)
        }
    }
}
