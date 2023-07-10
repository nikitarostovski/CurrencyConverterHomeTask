//
//  MainViewController.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class MainViewController: UIViewController, MainModuleView {
    var presenter: MainPresentable?
    
    private var collectionProvider: MainCollectionCellProvider?
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bounces = true
        view.delaysContentTouches = false
        view.alwaysBounceVertical = true
        view.backgroundColor = Colors.background1
        return view
    }()
    
    private lazy var amountInputView: AmountInputView = {
        let view = AmountInputView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var retryButton: ActionButton = {
        let button = ActionButton()
        button.setTitle(Strings.Buttons.retry.localized, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(onRetryTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap))
    }()
    
    private var amountInputViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(tapGestureRecognizer)
        view.backgroundColor = Colors.background1
        
        setupSubviews()
        presenter?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onViewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset.top = amountInputView.frame.maxY - view.safeAreaInsets.top + Constants.collectionTopInset
        collectionView.contentInset.bottom = Constants.collectionTopInset
        collectionProvider?.updateCellSize()
    }

    private func setupSubviews() {
        view.addSubview(collectionView)
        view.addConstraints([
            .init(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            .init(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            .init(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            .init(item: collectionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        ])
        
        view.addSubview(retryButton)
        retryButton.isHidden = true
        view.addConstraints([
            .init(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: collectionView, attribute: .centerX, multiplier: 1, constant: 0),
            .init(item: retryButton, attribute: .centerY, relatedBy: .equal, toItem: collectionView, attribute: .centerY, multiplier: 1, constant: 0),
            .init(item: retryButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.retryButtonWidth),
            .init(item: retryButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.retryButtonHeight)
        ])
        
        view.addSubview(amountInputView)
        let amountInputViewHeight = NSLayoutConstraint(item: amountInputView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: AmountInputView.Constants.viewHeight.upperBound)
        self.amountInputViewHeight = amountInputViewHeight
        view.addConstraints([
            .init(item: amountInputView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
            .init(item: amountInputView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            .init(item: amountInputView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
            amountInputViewHeight
        ])
    }
    
    func update(_ viewModel: MainViewModel) {
        defer { collectionView.reloadData() }
        let verticalOffset = collectionView.contentOffset.y
        
        var collectionProvider: MainCollectionCellProvider?
        var collectionViewUserInteractionEanbled = false
        let amountInputViewState: AmountInputView.State
        var retryButtonIsHidden = true
        var currencyButtonTitile = viewModel.selectedCurrency
        
        switch viewModel.state {
        case .currencySelection:
            amountInputViewState = .noCurrencySelected
            currencyButtonTitile = Strings.Buttons.select.localized
        case .failure:
            amountInputViewState = .statusOnly
            retryButtonIsHidden = false
        case .loading:
            amountInputViewState = .noData
            retryButton.isHidden = true
        case .normal:
            amountInputViewState = .normal
            collectionViewUserInteractionEanbled = true
            let dataSource = MainCollectionDataSource(viewModel.convertions)
            collectionProvider = .init(dataSource: dataSource, view: collectionView)
            collectionProvider?.delegate = self
        }
        
        self.collectionProvider = collectionProvider
        collectionView.isUserInteractionEnabled = collectionViewUserInteractionEanbled
        
        retryButton.isHidden = retryButtonIsHidden
        
        amountInputView.state = amountInputViewState
        amountInputView.statusText = viewModel.status
        amountInputView.placeholder = viewModel.amountInputPlaceholder
        amountInputView.selectedCurrencyCode = currencyButtonTitile
        
        if viewModel.amountNeedsUpdate {
            amountInputView.amount = viewModel.amount
        }
        if collectionView.contentOffset.y != verticalOffset {
            collectionView.contentOffset.y = verticalOffset
        }
    }
    
    @objc
    func onRetryTap() {
        retryButton.isHidden = true
        presenter?.onRetryTap()
    }
    
    @objc
    func onBackgroundTap() {
        amountInputView.resignFirstResponder()
    }
}

extension MainViewController: MainCollectionDelegate {
    func collectionViewDidStartScrolling() {
        amountInputView.resignFirstResponder()
    }
    
    func collectionViewDidChangeScrollOffset(_ offset: CGPoint) {
        let value = -offset.y - Constants.collectionTopInset - view.safeAreaInsets.top
        amountInputViewHeight.constant = AmountInputView.Constants.viewHeight.clamp(value)
    }
    
    func collectionViewDidEndDeceleration(direction: CollectionScrollDirection?) {
        let height = amountInputViewHeight.constant
        let bounds = AmountInputView.Constants.viewHeight
        guard height > bounds.lowerBound && height < bounds.upperBound else { return }
        
        let targetHeight: CGFloat
        if let direction = direction {
            // towards scroll direction
            targetHeight = direction == .down ? bounds.upperBound : bounds.lowerBound
        } else {
            // closest bound
            let toLo = height - bounds.lowerBound
            let toHi = bounds.upperBound - height
            targetHeight = toLo > toHi ? bounds.upperBound : bounds.lowerBound
        }
        
        let heightToAdd = targetHeight - height
        amountInputViewHeight.constant += heightToAdd
        
        UIView.animate(withDuration: Constants.Animation.duration,
                       delay: 0,
                       usingSpringWithDamping: Constants.Animation.springDamping,
                       initialSpringVelocity: Constants.Animation.initialSpringVelocity,
                       options: .curveEaseInOut,
                       animations: {
                            self.collectionView.contentOffset.y -= heightToAdd
                            self.view.layoutIfNeeded()
                       })
    }
}

extension MainViewController: AmountInputViewDelegate {
    func amountInputViewDidChangeAmount(_ value: Decimal?) {
        presenter?.onAmountChanged(value)
    }
    
    func amountInputViewDidTapCurrency() {
        amountInputView.resignFirstResponder()
        presenter?.onCurrencyTap()
    }
}

extension MainViewController {
    enum Constants {
        enum Animation {
            static var duration: TimeInterval = 0.4
            static var springDamping: CGFloat = 0.7
            static var initialSpringVelocity: CGFloat = 0.5
        }
        
        static let collectionTopInset: CGFloat = 16
        static let retryButtonWidth: CGFloat = 100
        static let retryButtonHeight: CGFloat = 52
    }
}
