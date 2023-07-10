//
//  CurrencyListBuilder.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class CurrencyListBuilder {
    static func build(currencyService: CurrencyService) -> UIViewController {
        let presenter = CurrencyListPresenter(currencyService: currencyService)
        let router = CurrencyListRouter()
        let view = CurrencyListViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return UINavigationController(rootViewController: view)
    }
}
