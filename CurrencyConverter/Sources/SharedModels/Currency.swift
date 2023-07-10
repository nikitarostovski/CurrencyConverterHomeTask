//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

// Consider CurrencyCode type as slightly validated code string
typealias CurrencyCode = String

extension CurrencyCode {
    init?(code: String?) {
        guard let code = code, code.isValidCurrencyCode else { return nil }
        self = code
    }
}

fileprivate extension String {
    var containsOnlyLetters: Bool {
        let notLetters = NSCharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    var isValidCurrencyCode: Bool {
        count == 3 && containsOnlyLetters
    }
}
