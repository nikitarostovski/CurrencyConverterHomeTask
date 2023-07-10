//
//  ExchangeDataMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
@testable import CurrencyConverter

extension ExchangeData {
    static let base = "JPY"
    static let currencies = ["USD", "THB", "EUR", "RUB"]

    static let rates = currencies.enumerated().compactMap {
        Rate(baseCode: base, currencyCode: $1, rate: Decimal($0))
    }

    static let mock = ExchangeData(timestamp: Date(), baseCode: base, rates: rates)
}
