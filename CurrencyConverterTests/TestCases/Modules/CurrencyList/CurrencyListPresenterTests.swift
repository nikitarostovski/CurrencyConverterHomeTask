//
//  CurrencyListPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CurrencyListPresenterTests: XCTestCase {
    private let defaultTimeout: TimeInterval = .reasonableTimeout

    private var currencyService: CurrencyServiceMock!
    private var view: CurrencyListViewMock!
    private var router: CurrencyListRouterMock!

    override func tearDown() {
        super.tearDown()
        view = nil
        currencyService = nil
        router = nil
    }

    private func makePresenter(preConfigured: Bool = true) -> CurrencyListPresenter {
        let currencyService = CurrencyServiceMock()
        let presenter = CurrencyListPresenter(currencyService: currencyService)
        let view = CurrencyListViewMock()
        let router = CurrencyListRouterMock()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router

        self.router = router
        self.view = view
        self.currencyService = currencyService

        if preConfigured {
            presenter.onViewWillAppear()

            view.clear()
            router.clear()
            currencyService.clear()
        }

        return presenter
    }

    func testCurrencyListPresenter_callsRouterOnItemSelect() {
        let presenter = makePresenter()
        
        presenter.allCurrencies = [""]
        presenter.onCurrencyTap(at: 0)

        XCTAssertEqual(router.callCount, 1)
    }

    func testCurrencyListPresenter_restoresCurrencyServiceDelegateOnViewWillDisappear() {
        let delegate = CurrencyServiceDelegateSpy()
        let presenter = makePresenter(preConfigured: false)
        currencyService.delegate = delegate
        
        presenter.onViewWillAppear()
                                    
        presenter.onViewWillDisappear()

        XCTAssertTrue(currencyService.delegate === delegate)
    }

    func testCurrencyListPresenter_updatesViewOnViewWillAppear() {
        let promise = expectation(description: "view has been updated")
        let presenter = makePresenter()
        view.updateExpectationToFullfill = promise

        presenter.onViewWillAppear()

        wait(for: [promise], timeout: defaultTimeout)
    }

    func testCurrencyListPresenter_updatesViewOnServiceUpdate() {
        let promise = expectation(description: "view has been updated")
        let _ = makePresenter()
        view.updateExpectationToFullfill = promise

        currencyService.triggerDelegateCall()
        
        wait(for: [promise], timeout: defaultTimeout)
    }
    
    func testCurrencyListPresenter_callsScrollToIndexOnStart() {
        let promise = expectation(description: "view's scrollToIndex method has been called")
        let presenter = makePresenter(preConfigured: false)
        presenter.selectedCurrency = ""
        view.scrollToIndexExpectationToFullfill = promise
        
        presenter.onViewWillAppear()

        wait(for: [promise], timeout: defaultTimeout)
    }
}
