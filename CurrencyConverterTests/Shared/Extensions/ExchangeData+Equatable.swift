//
//  ExchangeData+Equatable.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation
@testable import CurrencyConverter

extension ExchangeData: Equatable {
    public static func == (lhs: CurrencyConverter.ExchangeData, rhs: CurrencyConverter.ExchangeData) -> Bool {
        lhs.baseCode == rhs.baseCode &&
        lhs.timestamp == rhs.timestamp &&
        lhs.allRates == rhs.allRates
    }
}
