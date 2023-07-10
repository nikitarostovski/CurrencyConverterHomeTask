//
//  ConversionResultCell.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

class ConversionResultCell: UICollectionViewCell {
    static var identifier: String { String(describing: Self.self) }
    
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImage = UIImage.corneredRectBackground(radius: Constants.cellCornerRadius)
        let imageView = UIImageView(image: backgroundImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Colors.background2
        return imageView
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: Constants.primaryFontSize)
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 0
        label.textColor = Colors.primaryText
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var symbolBackgroundImageView: UIImageView = {
        let backgroundImage = UIImage.corneredRectBackground(radius: Constants.symbolCornerRadius)
        let imageView = UIImageView(image: backgroundImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Colors.background1
        return imageView
    }()
    
    private lazy var symbolLabel: BadgeLabel = {
        let label = BadgeLabel()
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: Constants.primaryFontSize)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.cornerRadius = Constants.badgeCornerRadius
        label.badgeInsets = Constants.badgeInsets
        return label
    }()
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: Constants.secondaryFontSize)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.textColor = Colors.primaryText
        return label
    }()
    
    private var viewModel: ViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundImageView)
        addConstraints([
            .init(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
        ])
        
        addSubview(nameLabel)
        addConstraints([
            .init(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: Constants.horizontalInset),
            .init(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: Constants.verticalInset)
        ])
        
        addSubview(symbolLabel)
        addConstraints([
            .init(item: symbolLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalInset),
            .init(item: symbolLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: Constants.verticalInset),
            .init(item: symbolLabel, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: nameLabel, attribute: .trailing, multiplier: 1, constant: Constants.horizontalInset)
        ])
        
        insertSubview(symbolBackgroundImageView, belowSubview: symbolLabel)
        addConstraints([
            .init(item: symbolBackgroundImageView, attribute: .width, relatedBy: .equal, toItem: symbolLabel, attribute: .width, multiplier: 1, constant: 0),
            .init(item: symbolBackgroundImageView, attribute: .height, relatedBy: .equal, toItem: symbolLabel, attribute: .height, multiplier: 1, constant: 0),
            .init(item: symbolBackgroundImageView, attribute: .top, relatedBy: .equal, toItem: symbolLabel, attribute: .top, multiplier: 1, constant: 0),
            .init(item: symbolBackgroundImageView, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: symbolLabel, attribute: .leading, multiplier: 1, constant: 0)
        ])
        
        addSubview(amountLabel)
        addConstraints([
            .init(item: amountLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: Constants.horizontalInset),
            .init(item: amountLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalInset),
            .init(item: amountLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: symbolLabel, attribute: .bottom, multiplier: 1, constant: Constants.verticalInset),
            .init(item: amountLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: amountLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -Constants.verticalInset)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        symbolLabel.textColor = newWindow?.tintColor
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        nameLabel.preferredMaxLayoutWidth = bounds.width / 2
    }
    
    func configure(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        
        symbolLabel.text = viewModel.symbol
        amountLabel.text = viewModel.amount
        nameLabel.text = viewModel.name
    }
}

extension ConversionResultCell {
    struct ViewModel {
        let name: String?
        let amount: String
        let symbol: String
    }
}

extension ConversionResultCell {
    enum Constants {
        static let horizontalInset: CGFloat = 8
        static let verticalInset: CGFloat = 4
        
        static let primaryFontSize: CGFloat = 14
        static let secondaryFontSize: CGFloat = 10
        
        static let cellCornerRadius: CGFloat = 8
        static let symbolCornerRadius: CGFloat = 4
        
        static let badgeCornerRadius: CGFloat = 8
        static let badgeInsets: UIEdgeInsets = .init(top: 2, left: 3, bottom: 2, right: 3)
    }
}
