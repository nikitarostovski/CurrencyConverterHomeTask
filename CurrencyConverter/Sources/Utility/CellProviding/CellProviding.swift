//
//  CollectionCellProviding.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

public protocol CellProviding: NSObject {
    associatedtype Source: DataSource
    associatedtype View: UIView

    var dataSource: Source { get }
    var view: View! { get }

    init(dataSource: Source, view: View)
    func registerCells()
    func configureView()
}

