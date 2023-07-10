//
//  ActionButton.swift
//  CurrencyConverter
//
//  Created by Rost on 17.06.2023.
//

import UIKit

class ActionButton: UIButton {
    private lazy var backgroundImageView: UIImageView = {
        let backgroundImage = UIImage.corneredRectBackground(radius: Constants.cornerRadius)
        let imageView = UIImageView(image: backgroundImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Colors.background2
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        insertSubview(backgroundImageView, at: 0)
        addConstraints([
            .init(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
        ])
        
        setTitleColor(Colors.buttonText, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: Constants.fontSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        backgroundImageView.tintColor = newWindow?.tintColor
    }
}

extension ActionButton {
    enum Constants {
        static let cornerRadius: CGFloat = 4
        static let fontSize: CGFloat = 18
    }
}
