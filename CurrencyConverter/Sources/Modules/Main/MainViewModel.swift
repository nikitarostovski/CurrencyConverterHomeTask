//
//  MainViewModel.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

struct MainViewModel {
    enum State {
        case normal
        case currencySelection
        case loading
        case failure
    }
    
    struct ConvertionResult {
        let currencyName: String?
        let currencySymbol: String
        let amountString: String
    }
    
    let state: State
    let amountNeedsUpdate: Bool
    let amount: Decimal?
    let amountInputPlaceholder: String?
    let status: String?
    let selectedCurrency: CurrencyCode?
    
    let convertions: [ConvertionResult]
}
