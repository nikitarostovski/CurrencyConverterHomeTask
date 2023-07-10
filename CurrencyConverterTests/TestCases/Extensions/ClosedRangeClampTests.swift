//
//  ClosedRangeClampTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class ClosedRangeClampTests: XCTestCase {
    func testRangeClamping_insideBounds() {
        let range = 0...10
        let values = [0, 2, 8, 10]
        
        values.forEach {
            let clamped = range.clamp($0)
            XCTAssertEqual(clamped, $0)
        }
    }
    
    func testRangeClamping_outsideBounds() {
        let range = 5...10
        let lowerValues = [-10_000_000, -3, 0, 2, 4, 5]
        let greaterValues = [10, 12, 10_000_000]
        
        lowerValues.forEach {
            let clamped = range.clamp($0)
            XCTAssertEqual(clamped, range.lowerBound)
        }
        
        greaterValues.forEach {
            let clamped = range.clamp($0)
            XCTAssertEqual(clamped, range.upperBound)
        }
    }
}
