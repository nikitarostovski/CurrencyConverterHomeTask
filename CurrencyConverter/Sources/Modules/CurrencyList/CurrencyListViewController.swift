//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class CurrencyListViewController: UIViewController, CurrencyListModuleView {
    var presenter: CurrencyListPresentable?
    
    private var tableProvider: CurrencyTableCellProvider?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.sectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude))
        return tableView
    }()
    
    private lazy var closeButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(Strings.Buttons.close.localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onCloseButtonTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Strings.Messages.selectBaseCurrency.localized
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.onViewWillDisappear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset.bottom = view.frame.height - closeButton.frame.minY - Constants.verticalInset
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        view.addConstraints([
            .init(item: tableView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            .init(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            .init(item: tableView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            .init(item: tableView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        view.addSubview(closeButton)
        view.addConstraints([
            .init(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.buttonHeight),
            .init(item: closeButton, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: closeButton, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: -Constants.verticalInset),
            .init(item: closeButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: Constants.horizontalInset),
            .init(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalInset)
        ])
    }
    
    func scrollToIndex(_ indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
    
    func update(_ viewModel: CurrencyListViewModel?) {
        defer { tableView.reloadData() }
        guard let viewModel = viewModel else {
            tableProvider = nil
            return
        }
        
        let dataSource = CurrencyTableDataSource(currencies: viewModel.currencies, selectedIndex: viewModel.selectedIndex)
        let provider = CurrencyTableCellProvider(dataSource: dataSource, view: tableView)
        provider.delegate = self
        tableProvider = provider
    }
    
    @objc
    private func onCloseButtonTap() {
        presenter?.onCloseTap()
    }
}

extension CurrencyListViewController: CurrencyTableDelegate {
    func didSelectCurrency(at index: Int) {
        presenter?.onCurrencyTap(at: index)
    }
}

extension CurrencyListViewController {
    enum Constants {
        static var horizontalInset: CGFloat = 32
        static var verticalInset: CGFloat = 16
        static var buttonHeight: CGFloat = 52
    }
}
