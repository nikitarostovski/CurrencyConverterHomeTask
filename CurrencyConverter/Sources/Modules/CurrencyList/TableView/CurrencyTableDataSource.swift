//
//  CurrencyTableDataSource.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import Foundation

final class CurrencyTableDataSource: DataSource {
    typealias CellModel = CurrencyCell.ViewModel
    
    private let models: [CellModel]
    
    subscript(position: Int) -> CellModel { models[position] }
    
    init(currencies: [CurrencyListViewModel.CurrencyData], selectedIndex: Int?) {
        let selectedCode = selectedIndex == nil ? "" : currencies[selectedIndex!].code
        self.models = currencies.map { currency in
            let isSelected = selectedCode == currency.code
            return CellModel(name: currency.name, symbol: currency.code, isSelected: isSelected)
        }
    }
    
    func count(for section: Int) -> Int {
        models.count
    }
}
