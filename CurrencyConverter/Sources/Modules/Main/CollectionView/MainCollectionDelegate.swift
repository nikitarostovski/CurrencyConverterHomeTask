//
//  PairsCollectionDelegate.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import Foundation

enum CollectionScrollDirection {
    case up
    case down
}

protocol MainCollectionDelegate: AnyObject {
    func collectionViewDidStartScrolling()
    func collectionViewDidChangeScrollOffset(_ offset: CGPoint)
    func collectionViewDidEndDeceleration(direction: CollectionScrollDirection?)
}

extension MainCollectionDelegate {
    func collectionViewDidChangeScrollOffset(_ offset: CGPoint) { }
    func collectionViewDidEndDeceleration(direction: CollectionScrollDirection?) { }
}
