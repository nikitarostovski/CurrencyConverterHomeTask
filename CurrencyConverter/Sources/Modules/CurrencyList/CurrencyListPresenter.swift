//
//  CurrencyListPresenter.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class CurrencyListPresenter: CurrencyListPresentable {
    private let currencyService: CurrencyService
    private weak var oldCurrencyServiceDelegate: CurrencyServiceDelegate?
    
    weak var view: CurrencyListModuleView?
    var router: CurrencyListRouting?
    
    var allCurrencies: [CurrencyCode] = []
    
    var selectedCurrency: CurrencyCode? {
        get { currencyService.selectedCurrency }
        set { currencyService.selectedCurrency = newValue }
    }
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
    func onViewWillAppear() {
        oldCurrencyServiceDelegate = currencyService.delegate
        currencyService.delegate = self
        // No need to call updateView() here, because currencyService calls its delegate right after assign
    }
    
    func onViewWillDisappear() {
        currencyService.delegate = oldCurrencyServiceDelegate
        oldCurrencyServiceDelegate = nil
    }
    
    func onCurrencyTap(at index: Int) {
        self.selectedCurrency = allCurrencies[index]
        guard let view = view else { return }
        updateView()
        router?.dismiss(from: view)
    }
    
    func onCloseTap() {
        guard let view = view else { return }
        router?.dismiss(from: view)
    }
    
    private func updateView(scrollToSelected: Bool = false) {
        Task {
            let model: CurrencyListViewModel
            let result = await currencyService.getAvailableCurrencies()
            let selectedIndex: Int?
            
            switch result {
            case .success(let currencies):
                selectedIndex = selectedCurrency == nil ? nil : currencies.firstIndex(of: selectedCurrency!)
                let data: [CurrencyListViewModel.CurrencyData] = currencies.map {
                    let symbol = String.currencySymbol(for: $0)
                    let name = currencyService.getCurrencyName($0)
                    return .init(code: symbol, name: name)
                }
                model = CurrencyListViewModel(selectedIndex: selectedIndex, currencies: data)
                allCurrencies = currencies
            case .failure(let error):
                selectedIndex = nil
                model = CurrencyListViewModel(selectedIndex: nil, currencies: [])
                allCurrencies = []
                switch error {
                case .unableToGetData:
                    print(error)
                }
            }
            await MainActor.run {
                view?.update(model)
                if scrollToSelected, let row = selectedIndex {
                    view?.scrollToIndex(IndexPath(row: row, section: 0))
                }
            }
        }
    }
}

extension CurrencyListPresenter: CurrencyServiceDelegate {
    func currencyServiceDidUpdateData() {
        updateView(scrollToSelected: true)
    }
}
