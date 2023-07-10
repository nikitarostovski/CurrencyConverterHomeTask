//
//  CombinedSourceCurrencyServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class CombinedSourceCurrencyServiceTests: XCTestCase {
    private let extraTimeout: TimeInterval = .reasonableTimeout
    
    private let timeBetweenRequests: TimeInterval = 0
    private let networkDelay: TimeInterval = .networkDelay
    
    private func makeService(dataUpdateMode: CombinedSourceCurrencyService.DataUpdateMode = .manual, forceError: Bool = false) -> CombinedSourceCurrencyService {
        let userDefaults = UserDefaultsSpy()
        let storage = StorageSpy()
        let networkService = MockedNetworkService(delay: networkDelay)
        let storageProvider = PersistentStorageService(storage: storage, userDefaults: userDefaults)
        let apiService = OpenExchangeRatesAPIService(networkService: networkService, appID: "")
        networkService.forceError = forceError
        return CombinedSourceCurrencyService(apiService: apiService,
                                                storageService: storageProvider,
                                                timeBetweenRequests: timeBetweenRequests,
                                                dataUpdateMode: dataUpdateMode)
    }
    
    func testCurrencyService_callsDelegateOnAssign() async {
        let delegate = CurrencyServiceDelegateSpy()
        let service = makeService()
        service.delegate = delegate
        
        XCTAssertEqual(delegate.callCount, 1)
    }
    
    func testCurrencyService_callsDelegateOnDataUpdate() {
        let promise = expectation(description: "delegate has been called after data update")
        
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        let initialCallCount = delegate.callCount
        
        service.reloadDataIfAvailable()
        
        XCTAssertEqual(delegate.callCount, initialCallCount)
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
    }
    
    func testCurrencyService_retryIsUnavailableDuringRequest() {
        let service = makeService()
        
        service.reloadDataIfAvailable()
        Thread.sleep(forTimeInterval: networkDelay / 2)
        
        XCTAssertFalse(service.retryAvailable)
    }
    
    func testCurrencyService_retryIsAvailableAfterRequest() {
        let promise = expectation(description: "reloading finished")
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.reloadDataIfAvailable()
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        XCTAssertTrue(service.retryAvailable)
    }
    
    func testCurrencyService_lastDataUpdateTimeNotNil() {
        let promise = expectation(description: "reloading finished")
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.reloadDataIfAvailable()
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        XCTAssertNotNil(service.lastDataUpdateTime)
    }
    
    func testCurrencyService_lastDataUpdateTimeNil() {
        let promise = expectation(description: "reloading finished")
        
        let service = makeService(forceError: true)
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.reloadDataIfAvailable()
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        XCTAssertNil(service.lastDataUpdateTime)
    }
    
    func testCurrencyService_exchangeDataCreationTimeNotNil() {
        let promise = expectation(description: "reloading finished")
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.reloadDataIfAvailable()
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        XCTAssertNotNil(service.exchangeDataCreationTime)
    }
    
    func testCurrencyService_exchangeDataCreationTimeNil() {
        let promise = expectation(description: "reloading finished")
        
        let service = makeService(forceError: true)
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.reloadDataIfAvailable()
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        XCTAssertNil(service.exchangeDataCreationTime)
    }
    
    func testCurrencyService_selectedCurrencyChangeTriggersReload() {
        let promise = expectation(description: "data has been updated")
        
        let service = makeService(dataUpdateMode: .manual)
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        service.selectedCurrency = CurrencyCode("USD")
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
    }
    
    func testCurrencyService_loadsAvailableCurrencies() async {
        let promise = expectation(description: "data has been updated")
        
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        await fulfillment(of: [promise], timeout: networkDelay + extraTimeout)
        let result = await service.getAvailableCurrencies()
        
        XCTAssertNoThrow(try result.get())
    }
    
    func testCurrencyService_throwsIfNoData() async {
        let service = makeService()
        
        let result = await service.getAvailableCurrencies()
        
        XCTAssertThrowsError(try result.get())
    }
    
    func testCurrencyService_returnsCurrencyNameIfFound() {
        let code = "USD"
        let expectedName = "United States Dollar"
        let promise = expectation(description: "data has been updated")
        
        let service = makeService()
        let delegate = CurrencyServiceDelegateSpy()
        service.delegate = delegate
        delegate.promiseToFullfill = promise
        
        wait(for: [promise], timeout: networkDelay + extraTimeout)
        let result = service.getCurrencyName(code)
        
        XCTAssertEqual(result, expectedName)
    }
}
