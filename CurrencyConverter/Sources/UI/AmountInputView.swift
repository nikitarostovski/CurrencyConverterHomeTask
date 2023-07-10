//
//  AmountInputView.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import UIKit

protocol AmountInputViewDelegate: AnyObject {
    func amountInputViewDidChangeAmount(_ value: Decimal?)
    func amountInputViewDidTapCurrency()
}

class AmountInputView: UIView {
    enum State {
        case normal
        case noCurrencySelected
        case noData
        case statusOnly
    }
    
    private let amountSymbolLimit = 20
    private let charWhitelist = CharacterSet(charactersIn: "0123456789.")
    
    private lazy var bottomLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.outline
        return view
    }()
    
    private lazy var amountTextField: PaddingTextField = {
        let field = PaddingTextField()
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        field.keyboardType = .decimalPad
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderStyle = .roundedRect
        field.backgroundColor = Colors.background1
        field.textColor = Colors.primaryText
        field.padding = Constants.textFieldInsets
        field.delegate = self
        return field
    }()
    
    private lazy var currencyButton: ActionButton = {
        let button = ActionButton()
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: Constants.statusFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.secondaryText
        return label
    }()
    
    private lazy var inputStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = Constants.inputInteritemSpacing
        return stack
    }()
    
    private lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    private var lastAmount: Decimal?
    var state: State = .noData {
        didSet {
            updateState()
        }
    }
    weak var delegate: AmountInputViewDelegate?
    
    var placeholder: String? {
        get { amountTextField.placeholder }
        set { amountTextField.placeholder = newValue }
    }
    
    var isInputUserInteractionEnabled: Bool {
        get { amountTextField.isUserInteractionEnabled }
        set { amountTextField.isUserInteractionEnabled = newValue }
    }
    
    var statusText: String? {
        get { statusLabel.text }
        set { statusLabel.text = newValue }
    }
    
    var amount: Decimal? {
        set { setAmount(newValue) }
        get { getAmount() }
    }
    
    var selectedCurrencyCode: CurrencyCode? {
        get { currencyButton.currentTitle }
        set { currencyButton.setTitle(newValue, for: .normal) }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
        backgroundColor = Colors.background2
        
        layer.masksToBounds = false
        layer.shadowColor = Colors.shadow.cgColor
        layer.shadowRadius = Constants.shadowRadius
        layer.shadowOpacity = Constants.shadowOpacity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        amountTextField.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = frame.maxY - safeAreaInsets.top
        let progress = (height - Constants.viewHeight.lowerBound) / (Constants.viewHeight.upperBound - Constants.viewHeight.lowerBound)
        updateTransition(progress)
    }
    
    private func setupSubviews() {
        addSubview(bottomLineView)
        addSubview(loader)
        addSubview(statusLabel)
        addSubview(inputStack)
        inputStack.addArrangedSubview(amountTextField)
        inputStack.addArrangedSubview(currencyButton)
        
        let lineHeight = 1.0 / UIScreen.main.scale
        
        addConstraints([
            .init(item: bottomLineView, attribute: .leading, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: bottomLineView, attribute: .trailing, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: bottomLineView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: lineHeight),
            .init(item: bottomLineView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        addConstraints([
            .init(item: statusLabel, attribute: .leading, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: Constants.horizontalInset),
            .init(item: statusLabel, attribute: .trailing, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalInset),
            .init(item: statusLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.statusHeight),
            .init(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: Constants.verticalInset)
        ])
        
        addConstraints([
            .init(item: currencyButton, attribute: .height, relatedBy: .equal, toItem: inputStack, attribute: .height, multiplier: 1, constant: -2 * Constants.buttonVerticalInset),
            .init(item: currencyButton, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.buttonWidth)
        ])
        
        addConstraints([
            .init(item: loader, attribute: .centerX, relatedBy: .equal, toItem: inputStack, attribute: .centerX, multiplier: 1, constant: 0),
            .init(item: loader, attribute: .centerY, relatedBy: .equal, toItem: inputStack, attribute: .centerY, multiplier: 1, constant: 0),
        ])
        
        addConstraints([
            .init(item: amountTextField, attribute: .height, relatedBy: .equal, toItem: inputStack, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        addConstraints([
            .init(item: inputStack, attribute: .leading, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: Constants.horizontalInset),
            .init(item: inputStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.inputHeight),
            .init(item: inputStack, attribute: .trailing, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: -Constants.horizontalInset),
            .init(item: inputStack, attribute: .bottom, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -Constants.verticalInset)
        ])
    }
    
    @objc
    private func onButtonTap() {
        delegate?.amountInputViewDidTapCurrency()
    }
    
    private func setAmount(_ value: Decimal?) {
        guard let value = value else {
            amountTextField.text = ""
            return
        }
        amountTextField.text = value.formattedCurrency()
    }
    
    private func getAmount() -> Decimal? {
        return amountTextField.text?.amount
    }
    
    private func updateState() {
        switch state {
        case .normal:
            statusLabel.textAlignment = .natural
            amountTextField.isHidden = false
            currencyButton.isHidden = false
            loader.isHidden = true
        case .noCurrencySelected:
            currencyButton.setTitle(Strings.Buttons.select.localized, for: .normal)
            statusLabel.textAlignment = .center
            amountTextField.isHidden = true
            currencyButton.isHidden = false
            loader.isHidden = true
        case .noData:
            statusLabel.textAlignment = .center
            amountTextField.isHidden = true
            currencyButton.isHidden = true
            loader.isHidden = false
        case .statusOnly:
            statusLabel.textAlignment = .center
            amountTextField.isHidden = true
            currencyButton.isHidden = true
            loader.isHidden = true
        }
    }
    
    private func updateTransition(_ p: CGFloat) {
        let pRev = 1 - p
        let frp = Constants.statusFadeModifier * pRev
        statusLabel.alpha = 1 - frp
    }
}

extension AmountInputView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = textField.text?.trimmedAmount
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string = string.replacingOccurrences(of: ",", with: ".")
        let oldString = textField.text ?? ""
        let stringRange = Range(range, in: oldString)!
        let newString = oldString.replacingCharacters(in: stringRange, with: string)
        
        let parts = newString.split(separator: ".")
        let decimalPart = parts.first
        let fractionPart = parts.count > 1 ? parts.last : nil
        
        // check length
        if let decimalPart = decimalPart, decimalPart.count > amountSymbolLimit {
            return false
        }
        
        // check for fraction digit count
        if let fractionPart = fractionPart, fractionPart.count > 2 {
            return false
        }
        
        // check for unsupported symbols
        if string.rangeOfCharacter(from: charWhitelist.inverted) != nil {
            return false
        }
        
        // check for leading zero
        if string.first == "0", oldString == "0" {
            return false
        }
        
        // check for leading dot
        if oldString.isEmpty, newString.first == "." {
            return false
        }
        
        // check for dot total count
        if newString.reduce(into: 0, { $0 += $1 == "." ? 1 : 0 }) > 1 {
            return false
        }
        
        textField.text = newString
        
        let newAmount = getAmount()
        if newAmount != lastAmount || newAmount == nil {
            delegate?.amountInputViewDidChangeAmount(getAmount())
        }
        lastAmount = newAmount
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        setAmount(getAmount())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension AmountInputView {
    enum Constants {
        static var viewHeight: ClosedRange<CGFloat> = 84...126
        
        static var horizontalInset: CGFloat = 16
        static var verticalInset: CGFloat = 16
        static var buttonWidth: CGFloat = 96
        static var inputHeight: CGFloat = 52
        static var statusHeight: CGFloat = 30
        static var inputInteritemSpacing: CGFloat = 12
        static let textFieldInsets: UIEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 12)
        static let buttonVerticalInset: CGFloat = 1
        
        static var statusFadeModifier: CGFloat = 2
        
        static var shadowOpacity: Float = 0.15
        static var shadowRadius: CGFloat = 16
        
        static var statusFontSize: CGFloat = 14
    }
}
