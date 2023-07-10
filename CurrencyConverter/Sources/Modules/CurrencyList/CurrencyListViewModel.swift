//
//  CurrencyListViewModel.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

struct CurrencyListViewModel {
    struct CurrencyData {
        let code: String
        let name: String?
    }

    let selectedIndex: Int?
    let currencies: [CurrencyData]
}
