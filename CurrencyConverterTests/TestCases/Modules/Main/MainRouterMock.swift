//
//  MainRouterMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class MainRouterMock: MainRouting {
    var callCount = 0
    
    func goToCurrencySelection(from view: MainModuleView, currencyService: CurrencyService) {
        callCount += 1
    }
    
    func clear() {
        callCount = 0
    }
}
