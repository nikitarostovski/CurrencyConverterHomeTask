//
//  CurrencyServiceDelegateSpy.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyServiceDelegateSpy: CurrencyServiceDelegate {
    weak var promiseToFullfill: XCTestExpectation?
    var callCount = 0
    
    func currencyServiceDidUpdateData() {
        promiseToFullfill?.fulfill()
        callCount += 1
    }
}
