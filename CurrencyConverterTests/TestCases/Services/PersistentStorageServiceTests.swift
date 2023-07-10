//
//  PersistentStorageServiceTests.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
import XCTest
@testable import CurrencyConverter

final class PersistentStorageServiceTests: XCTestCase {
    var userDefaults: UserDefaultsSpy!
    var storage: StorageSpy!
    var service: PersistentStorageService!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaultsSpy()
        storage = StorageSpy()
        service = PersistentStorageService(storage: storage, userDefaults: userDefaults)
    }
    
    func testPersistentStorage_loadsExchangeData() async {
        let mock = ExchangeData.mock
        storage.lastObject = mock
        
        guard let result = try? service.loadLastExchangeData() as ExchangeData else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(result, mock)
    }
    
    func testPersistentStorage_savesExchangeData() async {
        let mock = ExchangeData.mock
        
        try? await service.saveCurrentExchangeData(mock)
        
        XCTAssert((storage.lastObject as? ExchangeData) == mock)
    }
    
    func testPersistentStorage_throwsOnLoadError() async {
        storage.shouldThrow = true
        
        var caughtError: Error?
        do {
            _ = try service.loadLastExchangeData()
        } catch {
            caughtError = error
        }
        XCTAssert(caughtError != nil)
    }
    
    func testPersistentStorage_throwsOnSaveError() async {
        storage.shouldThrow = true
        
        var caughtError: Error?
        do {
            try await service.saveCurrentExchangeData(.mock)
        } catch {
            caughtError = error
        }
        XCTAssert(caughtError != nil)
    }
    
    func testPersistentStorage_loadsSelectedCurrency() {
        let code = "USD"
        userDefaults.set(code, forKey: service.selectedCurrencyKey)
        
        guard let result = service.loadSelectedCurrency() else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(result, code)
    }
    
    func testPersistentStorage_savesSelectedCurrency() {
        let code = "USD"
        
        service.saveSelectedCurrency(code)
        
        XCTAssertEqual(userDefaults.lastValue as? String, code)
    }
}
