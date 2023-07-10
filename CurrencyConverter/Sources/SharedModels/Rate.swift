//
//  Rate.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

/// Model of an exchange rate between two currencies
struct Rate: Codable {
    /// Code of base currency
    let baseCode: CurrencyCode
    
    /// Code of target currency
    let currencyCode: CurrencyCode
    
    /// Target currency name
    var currencyName: String?
    
    /// Rate between `currencyCode` and `baseCode`
    let rate: Decimal?
}
