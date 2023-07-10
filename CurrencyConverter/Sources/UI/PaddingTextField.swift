//
//  PaddingTextField.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import UIKit

class PaddingTextField: UITextField {
    var padding: UIEdgeInsets = .zero

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
