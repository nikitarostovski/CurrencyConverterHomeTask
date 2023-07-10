//
//  MainCollectionDataSource.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

final class MainCollectionDataSource: DataSource {
    typealias CellModel = ConversionResultCell.ViewModel
    
    private var sections: [[CellModel]] = []
    
    init(_ items: [MainViewModel.ConvertionResult]) {
        self.sections = [items.map { conversion in
            CellModel(name: conversion.currencyName, amount: conversion.amountString, symbol: conversion.currencySymbol)
        }]
    }
    
    var numberOfSections: Int {
        sections.count
    }
    
    func count(for section: Int) -> Int {
        sections[section].count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CellModel {
        sections[indexPath.section][indexPath.row]
    }
}
