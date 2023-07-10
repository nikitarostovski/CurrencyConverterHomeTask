//
//  MainRouter.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class MainRouter: MainRouting {
    func goToCurrencySelection(from view: MainModuleView, currencyService: CurrencyService) {
        guard let view = view as? UIViewController else { return }
        let list = CurrencyListBuilder.build(currencyService: currencyService)
        view.present(list, animated: true)
    }
}
