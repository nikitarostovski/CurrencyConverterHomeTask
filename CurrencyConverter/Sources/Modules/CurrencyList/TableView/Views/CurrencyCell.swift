//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    static var identifier: String { String(describing: Self.self) }
    
    private lazy var symbolLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryText
        label.font = .boldSystemFont(ofSize: Constants.symbolFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 2
        label.textColor = Colors.primaryText
        label.font = .systemFont(ofSize: Constants.nameFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            updateStyle()
        }
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        addSubview(symbolLabel)
        addConstraints([
            .init(item: symbolLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: Constants.verticalPadding),
            .init(item: symbolLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: Constants.horizontalPadding),
            .init(item: symbolLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Constants.verticalPadding),
            .init(item: symbolLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.symbolMinWidth)
        ])
        
        addSubview(titleLabel)
        addConstraints([
            .init(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: Constants.verticalPadding),
            .init(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: symbolLabel, attribute: .trailing, multiplier: 1, constant: Constants.horizontalPadding),
            .init(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Constants.verticalPadding),
            .init(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalPadding)
        ])
    }
    
    func configure(_ viewModel: ViewModel) {
        symbolLabel.text = viewModel.symbol
        titleLabel.text = viewModel.name
        isSelected = viewModel.isSelected
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        isSelected = false
    }
    
    private func updateStyle() {
        accessoryType = isSelected ? .checkmark : .none
        backgroundColor = isSelected ? Colors.background2 : Colors.background1
    }
}

extension CurrencyCell {
    struct ViewModel {
        let name: String?
        let symbol: String
        let isSelected: Bool
    }
}

extension CurrencyCell {
    enum Constants {
        static let horizontalPadding: CGFloat = 32
        static let verticalPadding: CGFloat = 16
        static let symbolMinWidth: CGFloat = 48
        
        static let symbolFontSize: CGFloat = 16
        static let nameFontSize: CGFloat = 12
    }
}
