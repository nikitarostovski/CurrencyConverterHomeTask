//
//  BaseURL.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public struct BaseURL: Equatable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
