//
//  Colors.swift
//  CurrencyConverter
//
//  Created by Rost on 17.06.2023.
//

import UIKit

final class Colors {
    static let primaryText = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
    
    static let secondaryText = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.85, alpha: 1) : UIColor(white: 0.15, alpha: 1)
    }
    
    static let buttonText = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? .black: .white
    }
    
    static let background1 = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.05, alpha: 1) : UIColor(white: 0.98, alpha: 1)
    }
    
    static let background2 = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.15, alpha: 1) : UIColor(white: 0.9, alpha: 1)
    }
    
    static let shadow = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? .black: .black
    }
    
    static let outline = UIColor.init { (traitCollection) -> UIColor in
        return traitCollection.userInterfaceStyle == .dark ? UIColor(white: 0.1, alpha: 1): UIColor(white: 0.8, alpha: 1)
    }
}
