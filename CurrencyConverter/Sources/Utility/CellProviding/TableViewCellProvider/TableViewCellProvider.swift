//
//  TableViewCellProvider.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

open class TableViewCellProvider<Source: DataSource>: NSObject, CellProviding, UITableViewDataSource, UITableViewDelegate {
    public typealias View = UITableView

    public let dataSource: Source
    weak public var view: View!

    required public init(dataSource: Source, view: View) {
        self.dataSource = dataSource
        self.view = view
        super.init()
        
        self.view.dataSource = self
        self.view.delegate = self
        registerCells()
        configureView()
    }
    
    open func registerCells() { }
    
    open func configureView() {
        if #available(iOS 15, *) {
            view.sectionHeaderTopPadding = 0
        }
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        dataSource.sectionCount
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count(for: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
