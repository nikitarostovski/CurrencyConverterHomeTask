//
//  CurrencyListViewMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyListViewMock: CurrencyListModuleView {
    weak var presenter: CurrencyListPresentable?
    var updateCallCount = 0
    var scrollToIndexCallCount = 0
    weak var updateExpectationToFullfill: XCTestExpectation?
    weak var scrollToIndexExpectationToFullfill: XCTestExpectation?
    
    func update(_ viewModel: CurrencyConverter.CurrencyListViewModel?) {
        updateCallCount += 1
        updateExpectationToFullfill?.fulfill()
        updateExpectationToFullfill = nil
    }
    
    func scrollToIndex(_ indexPath: IndexPath) {
        scrollToIndexCallCount += 1
        scrollToIndexExpectationToFullfill?.fulfill()
        scrollToIndexExpectationToFullfill = nil
    }
    
    func clear() {
        updateCallCount = 0
        scrollToIndexCallCount = 0
        scrollToIndexExpectationToFullfill = nil
        updateExpectationToFullfill = nil
        presenter = nil
    }
}
