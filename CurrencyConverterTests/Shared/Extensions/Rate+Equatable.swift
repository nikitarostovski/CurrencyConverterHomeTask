//
//  RateMock.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
@testable import CurrencyConverter

extension Rate: Equatable {
    public static func == (lhs: Rate, rhs: Rate) -> Bool {
        lhs.baseCode == rhs.baseCode &&
        lhs.currencyCode == rhs.currencyCode &&
        lhs.rate == rhs.rate
    }
}
