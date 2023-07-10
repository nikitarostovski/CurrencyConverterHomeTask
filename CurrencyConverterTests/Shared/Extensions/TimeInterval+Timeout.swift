//
//  TimeInterval+Timeout.swift
//  CurrencyConverterTests
//
//  Created by Rost on 18.06.2023.
//

import Foundation

extension TimeInterval {
    static var networkDelay: Self { 0.1 }
    static var reasonableTimeout: Self { 2 }
}
