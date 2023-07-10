//
//  String+Decimal.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

extension String {
    private static let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        f.minimumFractionDigits = 0
        return f
    }()
    
    /// String with all symbols removed except for numbers and dot symbol
    var trimmedAmount: String {
        replacingOccurrences(of: "[^.0-9]", with: "", options: .regularExpression)
    }
    
    /// Number from current string contents
    var amount: Decimal? {
        Decimal(string: trimmedAmount)
    }
    
    /// Removes extra leading zeros. Removes not only first symbols, but checks for result string to be a nice-looking number
    /// - Returns: String with removed leading zeros
    func removingLeadingZeros() -> String {
        let parts = split(separator: ".").map { String($0) }
        guard var decimalPart = parts.first, !decimalPart.isEmpty else { return self }
        
        let isNegative = decimalPart.first == "-"
        decimalPart = decimalPart.replacingOccurrences(of: "-", with: "")
        decimalPart = decimalPart.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        if decimalPart.isEmpty {
            decimalPart = "0"
        }
        if isNegative {
            decimalPart = "-\(decimalPart)"
        }
        
        var newParts = parts
        newParts[0] = decimalPart
        return newParts.joined(separator: ".")
    }
    
    /// Removes all trailing spaces
    /// - Returns: String without a space at the end
    func removingTrailingSpaces() -> String {
        guard let regex = try? NSRegularExpression(pattern: "\\s+$") else { return self }
        let range = NSRange(startIndex..., in: self)
        return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
    }
    
    /// Tries to find a currency symbol for passed code in passed locale
    /// - Parameters:
    ///   - code: currency code ISO
    ///   - locale: locale to check for symbols. If nil passed, using default
    /// - Returns: currency symbol if found
    static func currencySymbol(for code: String, in locale: Locale? = nil) -> String {
        let f = Self.formatter
        if let locale = locale {
            f.locale = locale
        }
        f.currencyCode = code
        var result = f.string(from: 0)
        result = result?.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.,-+")).trimmingCharacters(in: .whitespaces)
        return result ?? code
    }
}
