//
//  MainPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class MainPresenterTests: XCTestCase {
    private let defaultTimeout: TimeInterval = .reasonableTimeout

    private var currencyService: CurrencyServiceMock!
    private var view: MainViewMock!
    private var router: MainRouterMock!

    override func tearDown() {
        super.tearDown()
        view = nil
        currencyService = nil
        router = nil
    }

    private func makePresenter(preConfigured: Bool = true) -> MainPresenter {
        let currencyService = CurrencyServiceMock()
        let presenter = MainPresenter(currencyService: currencyService)
        let view = MainViewMock()
        let router = MainRouterMock()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router

        self.router = router
        self.view = view
        self.currencyService = currencyService

        if preConfigured {
            presenter.onViewDidLoad()
            presenter.onViewWillAppear()

            view.clear()
            router.clear()
            currencyService.clear()
        }

        return presenter
    }

    func testMainPresenter_callsRouterOnCurrencyTap() {
        let presenter = makePresenter()
        
        presenter.onCurrencyTap()

        XCTAssertEqual(router.callCount, 1)
    }

    func testMainPresenter_callsCurrencyServiceOnRetryTap() {
        let presenter = makePresenter()
        
        presenter.onRetryTap()

        XCTAssertEqual(currencyService.reloadCallCount, 1)
    }

    func testMainPresenter_setsDefaultAmountOnViewDidLoad() {
        let presenter = makePresenter()

        presenter.onViewDidLoad()

        XCTAssertEqual(presenter.selectedAmount, presenter.defaultAmount)
    }

    func testMainPresenter_updatesViewOnViewWillAppear() {
        let promise = expectation(description: "view has been updated")
        let presenter = makePresenter()
        view.expectationToFullfill = promise

        presenter.onViewWillAppear()

        wait(for: [promise], timeout: defaultTimeout)
    }

    func testMainPresenter_updatesViewOnAmountChanged() {
        let promise = expectation(description: "view has been updated")
        let presenter = makePresenter()
        view.expectationToFullfill = promise

        presenter.onAmountChanged(123)
        
        wait(for: [promise], timeout: defaultTimeout)
    }

    func testMainPresenter_updatesViewOnServiceUpdate() {
        let promise = expectation(description: "view has been updated")
        let _ = makePresenter()
        view.expectationToFullfill = promise

        currencyService.triggerDelegateCall()
        
        wait(for: [promise], timeout: defaultTimeout)
    }
}
