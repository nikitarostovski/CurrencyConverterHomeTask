//
//  MainProtocols.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

protocol MainModuleView: AnyObject {
    var presenter: MainPresentable? { get }
    
    func update(_ viewModel: MainViewModel)
}

protocol MainPresentable: AnyObject {
    var view: MainModuleView? { get set }
    var router: MainRouting? { get set }

    func onViewDidLoad()
    func onViewWillAppear()
    func onCurrencyTap()
    func onAmountChanged(_ value: Decimal?)
    func onRetryTap()
}

protocol MainRouting {
    func goToCurrencySelection(from view: MainModuleView, currencyService: CurrencyService)
}
