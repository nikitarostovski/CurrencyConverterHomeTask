//
//  MainBuilder.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class MainBuilder {
    static func build(currencyService: CurrencyService) -> UIViewController {
        let presenter = MainPresenter(currencyService: currencyService)
        let router = MainRouter()
        let view = MainViewController()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view
    }
}
