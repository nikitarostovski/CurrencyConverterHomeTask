//
//  NetworkResponse.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public struct NetworkResponse {
    public let httpCode: Int?
    public let payload: Data?
    
    public init(httpCode: Int? = nil, payload: Data? = nil) {
        self.httpCode = httpCode
        self.payload = payload
    }
}
