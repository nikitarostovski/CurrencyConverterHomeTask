//
//  Strings.swift
//  CurrencyConverter
//
//  Created by Rost on 17.06.2023.
//

import Foundation

public protocol Localizable {
    var table: String { get }
    var bundle: Bundle { get }
    var localized: String { get }
}

public extension Localizable {
    var table: String { "Localizable" }
}

public extension Localizable where Self: RawRepresentable, Self.RawValue == String {
    var localized: String {
        return rawValue.localized(bundle: bundle, tableName: table)
    }
}

public extension String {
    var missingLocalizationPlaceholder: String {  "$\(self)$" }
    
    init(_ localizable: Localizable) {
        self.init(stringLiteral: localizable.localized)
    }
    
    func localized(bundle: Bundle, tableName: String) -> String {
        return NSLocalizedString(self,
                                 tableName: tableName,
                                 bundle: bundle,
                                 value: missingLocalizationPlaceholder,
                                 comment: "")
    }
}

public extension String.StringInterpolation {
    mutating func appendInterpolation(_ localizable: Localizable) {
        appendLiteral(localizable.localized)
    }
}

extension Localizable {
    var bundle: Bundle { .main }
}

public enum Strings {
    enum Buttons: String, Localizable, CaseIterable {
        case close
        case retry
        case select
    }
    
    enum Messages: String, Localizable, CaseIterable {
        case lastUpdated
        case selectBaseCurrency
        case noRatesAvailable
        case unknownError
        case loadingRates
    }
}
