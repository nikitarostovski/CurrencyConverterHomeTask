//
//  ClosedRange+Clamp.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

extension ClosedRange {
    /// Clamps passed value to closest bound
    /// - Parameter value: value to process
    /// - Returns: clamped value, [lowerBound...upperBound]
    func clamp(_ value: Bound) -> Bound {
        Swift.max(lowerBound, Swift.min(upperBound, value))
    }
}
