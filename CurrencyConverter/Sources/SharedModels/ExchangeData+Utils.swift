//
//  ExchangeData+Utils.swift
//  CurrencyConverter
//
//  Created by Rost on 17.06.2023.
//

import Foundation

extension ExchangeData {
    /// Performs conversion from one currency to all other
    /// - Parameter money: money data to convert
    /// - Returns: array of money in different currencies
    func convert(_ money: Money) -> [Money] {
        var baseRate: Decimal = 1
        if money.currencyCode != baseCode, let baseRateModel = allRates.first(where: { $0.currencyCode == money.currencyCode }) {
            baseRate = baseRateModel.rate ?? baseRate
        }
        return allRates.compactMap { rate -> Money? in
            guard rate.currencyCode != money.currencyCode, let value = rate.rate else { return nil }
            
            let crossRate = value / baseRate
            return Money(amount: money.amount * crossRate, currencyCode: rate.currencyCode, currencyName: rate.currencyName)
        }
    }
    
    /// Returns name for currency code
    /// - Parameter code: currency code
    /// - Returns: currency name
    func getCurrencyName(_ code: CurrencyCode) -> String? {
        allRates.first(where: { $0.currencyCode == code })?.currencyName
    }
}
