//
//  CollectionViewCellProvider.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

open class CollectionViewCellProvider<Source: DataSource>: NSObject, CellProviding, UICollectionViewDataSource, UICollectionViewDelegate {
    public typealias View = UICollectionView

    public let dataSource: Source
    weak public var view: View!

    required public init(dataSource: Source, view: View) {
        self.dataSource = dataSource
        self.view = view
        
        super.init()
        registerCells()
        configureView()
    }
    
    open func registerCells() { }
    
    open func configureView() { }
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSource.sectionCount
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count(for: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { }
}
