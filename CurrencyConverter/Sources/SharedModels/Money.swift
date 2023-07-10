//
//  Money.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

/// Object describing any amount of any currency
struct Money {
    /// Mony amount in `currencyCode` currency
    let amount: Decimal
    
    /// Currency code for money
    let currencyCode: CurrencyCode
    
    /// Name of currency
    let currencyName: String?
}
