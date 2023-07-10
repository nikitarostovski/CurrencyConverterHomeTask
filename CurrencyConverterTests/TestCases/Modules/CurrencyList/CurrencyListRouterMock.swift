//
//  CurrencyListRouterMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyListRouterMock: CurrencyListRouting {
    var callCount = 0
    
    func dismiss(from view: CurrencyListModuleView) {
        callCount += 1
    }
    
    func clear() {
        callCount = 0
    }
}
