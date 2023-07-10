//
//  CurrencyListProtocols.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

protocol CurrencyListModuleView: AnyObject {
    var presenter: CurrencyListPresentable? { get }
    
    func update(_ viewModel: CurrencyListViewModel?)
    func scrollToIndex(_ indexPath: IndexPath)
}

protocol CurrencyListPresentable: AnyObject {
    var view: CurrencyListModuleView? { get set }
    var router: CurrencyListRouting? { get set }

    func onViewWillAppear()
    func onViewWillDisappear()
    func onCurrencyTap(at index: Int)
    func onCloseTap()
}

protocol CurrencyListRouting {
    func dismiss(from view: CurrencyListModuleView)
}
