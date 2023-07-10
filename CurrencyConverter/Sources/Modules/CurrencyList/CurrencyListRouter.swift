//
//  CurrencyListRouter.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class CurrencyListRouter: CurrencyListRouting {
    func dismiss(from view: CurrencyListModuleView) {
        guard let view = view as? UIViewController else { return }
        view.dismiss(animated: true)
    }
}
