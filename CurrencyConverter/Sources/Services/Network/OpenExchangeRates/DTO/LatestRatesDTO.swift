//
//  LatestRatesDTO.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

struct LatestRatesDTO: Codable {
    let disclaimer: String
    let license: String
    let timestamp: Date
    let base: String
    let rates: [String: Decimal]
}
