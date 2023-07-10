//
//  MainViewMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class MainViewMock: MainModuleView {
    weak var presenter: MainPresentable?
    var updateCallCount = 0
    weak var expectationToFullfill: XCTestExpectation?
    
    func update(_ viewModel: MainViewModel) {
        expectationToFullfill?.fulfill()
        updateCallCount += 1
        expectationToFullfill = nil
    }
    
    func clear() {
        updateCallCount = 0
        expectationToFullfill = nil
        presenter = nil
    }
}
