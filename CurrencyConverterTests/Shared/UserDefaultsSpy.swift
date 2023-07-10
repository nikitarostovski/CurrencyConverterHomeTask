//
//  UserDefaultsSpy.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import UIKit

final class UserDefaultsSpy: UserDefaults {
    var lastValue: Any?
    var lastKey: String?
        
    override func set(_ value: Any?, forKey key: String) {
        lastValue = value
        lastKey = key
    }
    
    override func string(forKey defaultName: String) -> String? {
        lastValue as? String
    }
}
