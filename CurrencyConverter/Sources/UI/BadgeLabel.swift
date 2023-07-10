//
//  BadgeLabel.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import UIKit

class BadgeLabel: UILabel {
    var badgeInsets: UIEdgeInsets = .zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: badgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + badgeInsets.left + badgeInsets.right
        let height = superContentSize.height + badgeInsets.top + badgeInsets.bottom
        return CGSize(width: width, height: height)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + badgeInsets.left + badgeInsets.right
        let heigth = superSizeThatFits.height + badgeInsets.top + badgeInsets.bottom
        return CGSize(width: width, height: heigth)
    }
}
