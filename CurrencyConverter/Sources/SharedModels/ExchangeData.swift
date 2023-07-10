//
//  ExchangeData.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

/// Object containing all data necessary to perform exchange operations
struct ExchangeData: Codable {
    /// Date when current instance was initially created
    let createDate: Date?
    
    /// Date when exchange data was created (on server)
    let timestamp: Date
    
    /// Base currency for conversions
    let baseCode: CurrencyCode?
    
    /// Rate models between base currency(`baseCode`) and all currencies available
    private(set) var allRates: [Rate]
    
    /// All currencies found in rates available
    var allCurrencies: [CurrencyCode] {
        allRates.map { $0.currencyCode }.sorted()
    }
    
    init(createDate: Date? = nil, timestamp: Date, baseCode: String?, rates: [Rate]) {
        self.createDate = createDate
        self.timestamp = timestamp
        let baseCode = CurrencyCode(code: baseCode)
        self.baseCode = baseCode
        
        // Fill `allRates` with all currencies, including base if not present
        var allRates = rates
        if let baseCode = baseCode, !rates.contains(where: { $0.currencyCode == baseCode }) {
            let baseRate = Rate(baseCode: baseCode, currencyCode: baseCode, currencyName: nil, rate: 1)
            allRates.append(baseRate)
        }
        // Sort alphabetically
        self.allRates = allRates.sorted(by: { $0.currencyCode < $1.currencyCode })
    }
    
    /// Adds passed names for currencies if found
    /// - Parameter names: dictionary with names for currency codes. Key is code, Value is name
    mutating func addCurrencyNames(_ names: [String: String]) {
        allRates = allRates.map {
            var res = $0
            res.currencyName = names[res.currencyCode] ?? res.currencyName
            return res
        }
    }
}
