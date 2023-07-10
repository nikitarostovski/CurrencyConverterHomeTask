//
//  MainPresenter.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class MainPresenter: MainPresentable {
    enum ConversionError: Error {
        case invalidInput
        case dataUnavailable
    }
    
    private let currencyService: CurrencyService
    let defaultAmount: Decimal = 1
    
    weak var view: MainModuleView?
    var router: MainRouting?
    
    var selectedAmount: Decimal?
    
    var selectedCurrency: CurrencyCode? {
        currencyService.selectedCurrency
    }
    
    init(currencyService: CurrencyService) {
        self.currencyService = currencyService
    }
    
    func onViewDidLoad() {
        selectedAmount = defaultAmount
    }
    
    func onViewWillAppear() {
        currencyService.delegate = self
        currencyService.reloadDataIfAvailable()
        updateView(updateAmount: true)
    }
    
    func onCurrencyTap() {
        guard let view = view else { return }
        router?.goToCurrencySelection(from: view, currencyService: currencyService)
    }
    
    func onAmountChanged(_ value: Decimal?) {
        self.selectedAmount = value
        updateView()
        currencyService.reloadDataIfAvailable()
    }
    
    func onRetryTap() {
        updateView()
        currencyService.reloadDataIfAvailable()
    }
    
    private func convert(_ amount: Decimal) async throws -> [Money] {
        guard currencyService.exchangeDataCreationTime != nil else {
            throw ConversionError.dataUnavailable
        }
        guard let selectedCurrency = selectedCurrency else {
            throw ConversionError.invalidInput
        }
        let money = Money(amount: amount, currencyCode: selectedCurrency, currencyName: nil)
        
        let result = await currencyService.convert(money)
        
        switch result {
        case .success(let money):
            return money
        case .failure(let error):
            switch error {
            case .unableToGetData:
                throw ConversionError.dataUnavailable
            }
        }
    }
    
    private func updateView(updateAmount: Bool = false) {
        Task {
            let state: MainViewModel.State
            let status: String?
            
            // when selected amount is nil we want to show rate for default amount
            let amount = selectedAmount ?? defaultAmount
            let placeholder = defaultAmount.formattedCurrency()
            let currency = selectedCurrency == nil ? nil : String.currencySymbol(for: selectedCurrency!)
            var conversions = [MainViewModel.ConvertionResult]()
            
            do {
                let money = try await convert(amount)
                conversions = money.map {
                    let symbol = String.currencySymbol(for: $0.currencyCode)
                    let amountString = $0.amount.formattedCurrency()
                    return MainViewModel.ConvertionResult(currencyName: $0.currencyName, currencySymbol: symbol, amountString: amountString)
                }
                if selectedCurrency == nil {
                    state = .currencySelection
                    status = Strings.Messages.selectBaseCurrency.localized
                } else if let updateDate = currencyService.exchangeDataCreationTime {
                    state = .normal
                    status = "\(Strings.Messages.lastUpdated.localized) \(updateDate.formatted())"
                } else {
                    state = .failure
                    status = Strings.Messages.unknownError.localized
                }
            } catch {
                switch error {
                case ConversionError.invalidInput:
                    state = .currencySelection
                    status = Strings.Messages.selectBaseCurrency.localized
                    break
                default:
                    if currencyService.retryAvailable {
                        state = .failure
                        status = Strings.Messages.noRatesAvailable.localized
                    } else {
                        state = .loading
                        status = Strings.Messages.loadingRates.localized
                    }
                }
            }
            
            let model = MainViewModel(state: state,
                                      amountNeedsUpdate: updateAmount,
                                      amount: selectedAmount,
                                      amountInputPlaceholder: placeholder,
                                      status: status,
                                      selectedCurrency: currency,
                                      convertions: conversions)
            await MainActor.run {
                view?.update(model)
            }
        }
    }
}

extension MainPresenter: CurrencyServiceDelegate {
    func currencyServiceDidUpdateData() {
        updateView()
    }
}
