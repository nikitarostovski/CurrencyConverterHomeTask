//
//  MainCollectionCellProvider.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

final class MainCollectionCellProvider: CollectionViewCellProvider<MainCollectionDataSource> {
    private let cellId = ConversionResultCell.identifier
    
    weak var delegate: MainCollectionDelegate?
    
    private var scrollDirection: CollectionScrollDirection?
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.interitemSpacing
        layout.minimumLineSpacing = Constants.lineSpacing
        layout.estimatedItemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    
    var itemSize: CGSize {
        let count = 3
        let aspect: CGFloat = 1.5
        let totalWidth = view.bounds.width - view.contentInset.left - view.contentInset.right
        let cellWidth = totalWidth / CGFloat(count) - layout.minimumInteritemSpacing
        return CGSize(width: cellWidth, height: cellWidth / aspect)
    }
    
    override func registerCells() {
        view.register(ConversionResultCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func configureView() {
        view.collectionViewLayout = layout
        view.dataSource = self
        view.delegate = self
        view.allowsSelection = true
        view.contentInset.left = Constants.defaultPadding
        view.contentInset.right = Constants.defaultPadding
        view.showsVerticalScrollIndicator = false
    }
    
    func updateCellSize() {
        
        view.setCollectionViewLayout(view.collectionViewLayout, animated: true)
    }
    
    @objc(numberOfSectionsInCollectionView:)
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.numberOfSections
    }

    @objc
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count(for: section)
    }

    @objc
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ConversionResultCell else {
            return UICollectionViewCell()
        }
        let model = dataSource.cellViewModel(for: indexPath)
        cell.configure(model)
        return cell
    }
    
    @objc
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.collectionViewDidStartScrolling()
    }
    
    @objc
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.collectionViewDidEndDeceleration(direction: scrollDirection)
        }
    }
    
    @objc
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y == 0 {
            scrollDirection = nil
        } else if velocity.y < 0 {
            scrollDirection = .down
        } else {
            scrollDirection = .up
        }
    }
    
    @objc
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === view else { return }
        delegate?.collectionViewDidChangeScrollOffset(scrollView.contentOffset)
    }
    
    @objc
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === view, let scrollDirection = scrollDirection else { return }
        delegate?.collectionViewDidEndDeceleration(direction: scrollDirection)
    }
}

extension MainCollectionCellProvider: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize
    }
}

extension MainCollectionCellProvider {
    enum Constants {
        static var defaultPadding: CGFloat { 16 }
        static var interitemSpacing: CGFloat { 4 }
        static var lineSpacing: CGFloat { 8 }
    }
}
