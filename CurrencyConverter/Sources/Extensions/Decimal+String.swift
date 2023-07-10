//
//  Decimal+String.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

extension Decimal {
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        f.currencyCode = ""
        f.currencySymbol = ""
        f.currencyGroupingSeparator = " "
        return f
    }()
    
    ///  Formats the number and adds currency symbol in front
    /// - Parameter currencySymbol: currency symbol to attach in front of number
    /// - Returns: formatted string
    func formattedCurrency(_ currencySymbol: String? = nil) -> String {
        let numberString = Self.formatter.string(from: self as NSDecimalNumber) ?? ""
        let number = numberString.replacingOccurrences(of: ",", with: ".").removingTrailingSpaces()
        
        let components = [currencySymbol, number].compactMap { $0 }
        return components.joined(separator: " ")
    }
}
