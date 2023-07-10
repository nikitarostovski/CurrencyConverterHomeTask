//
//  CurrencyTableCellProvider.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import UIKit

final class CurrencyTableCellProvider: TableViewCellProvider<CurrencyTableDataSource> {
    private let cellId = CurrencyCell.identifier
    
    weak var delegate: CurrencyTableDelegate?
    
    override func registerCells() {
        view.register(CurrencyCell.self, forCellReuseIdentifier: cellId)
    }
    
    @objc
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CurrencyCell else {
            fatalError("no cell registered with id: \(cellId)")
        }
        cell.configure(self.dataSource[indexPath.row])
        
        return cell
    }
    
    @objc
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectCurrency(at: indexPath.row)
    }
}

extension CurrencyTableCellProvider {
    enum AccessibilityIds: String {
        case header
        case cell
    }
}
