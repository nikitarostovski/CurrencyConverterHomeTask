//
//  JSONAPICoder.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public final class JSONAPICoder: APICoder {
    public enum Error: APICoderError {
        case invalidDate
    }
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom(decodeDate)
        return decoder
    }()
    
    public init() { }
    
    public func encode<T: Encodable>(_ object: T) async throws -> Data {
        let handle = Task { () -> Data in
            return try encoder.encode(object)
        }
        return try await handle.value
    }
    
    public func decode<T>(_ type: T.Type, data: Data) async throws -> T where T : Decodable {
        let handle = Task { () -> T in
            return try decoder.decode(type, from: data)
        }
        return try await handle.value
    }
    
    private func decodeDate(_ decoder: Decoder) throws -> Date {
        let container = try decoder.singleValueContainer()
        
        guard let timestamp = try? container.decode(TimeInterval.self) else {
            throw Error.invalidDate
        }
        return Date(timeIntervalSince1970: timestamp)
    }
}
