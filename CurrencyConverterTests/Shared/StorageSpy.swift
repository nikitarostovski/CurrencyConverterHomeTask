//
//  StorageSpy.swift
//  CurrencyConverterTests
//
//  Created by Rost on 17.06.2023.
//

import Foundation
@testable import CurrencyConverter

final class StorageSpy: StorageProvider {
    enum StorageError: Error {
        case `default`
    }
    
    var lastObject: Any?
    var shouldThrow = false
    
    func save<T>(_ object: T, as fileName: String) throws where T : Encodable {
        if shouldThrow {
            throw StorageError.default
        }
        lastObject = object
    }
    
    func load<T>(_ fileName: String, as type: T.Type) throws -> T where T : Decodable {
        if !shouldThrow, let object = lastObject as? T {
            return object
        }
        throw StorageError.default
    }
}
