//
//  CurrencyTableDelegate.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import Foundation

protocol CurrencyTableDelegate: AnyObject {
    func didSelectCurrency(at index: Int)
}
