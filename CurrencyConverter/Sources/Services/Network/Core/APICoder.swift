//
//  APICoder.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public protocol APIDecoder {
    func decode<T: Decodable>(_ type: T.Type, data: Data) async throws -> T
}

public protocol APIEncoder {
    func encode<T: Encodable>(_ object: T) async throws -> Data
}

public typealias APICoder = APIEncoder & APIDecoder

public protocol APICoderError: Error { }
