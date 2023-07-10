//
//  PersistentStorageService.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

/// Stores and loads data needed for currency conversions. Basic types are stored in `UserDefaults`, Codable objects are dumped to file
final class PersistentStorageService {
    let exchangeDataFileName = "latestExchangeData"
    let selectedCurrencyKey = "selectedCurrencyKey"
    
    private var storage: StorageProvider
    private var userDefaults: UserDefaults
    
    init(storage: StorageProvider, userDefaults: UserDefaults) {
        self.storage = storage
        self.userDefaults = userDefaults
    }
    
    func loadLastExchangeData() throws -> ExchangeData {
        try storage.load(exchangeDataFileName, as: ExchangeData.self)
    }
    
    func saveCurrentExchangeData(_ exchangeData: ExchangeData) async throws {
        let handle = Task {
            try storage.save(exchangeData, as: exchangeDataFileName)
        }
        return try await handle.value
    }
    
    func saveSelectedCurrency(_ currency: CurrencyCode) {
        userDefaults.setValue(currency, forKey: selectedCurrencyKey)
    }
    
    func loadSelectedCurrency() -> CurrencyCode? {
        let codeString = userDefaults.string(forKey: selectedCurrencyKey)
        return CurrencyCode(code: codeString)
    }
}
