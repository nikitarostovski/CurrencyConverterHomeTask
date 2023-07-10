//
//  DataSource.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

public protocol DataSource {
    var sectionCount: Int { get }
    func count(for section: Int) -> Int
}

public extension DataSource {
    var sectionCount: Int { 1 }
}
