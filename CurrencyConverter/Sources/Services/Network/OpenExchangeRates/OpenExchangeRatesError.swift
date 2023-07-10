//
//  OpenExchangeRatesError.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

public enum OpenExchangeRatesError: EndpointError {
    case notFound
    case missingAppId
    case invalidAppId
    case notAllowed
    case accessRestricted
    case invalidBase
    
    init?(_ dto: GeneralErrorDTO) {
        guard dto.error else { return nil }
        switch dto.message {
        case .notFound: self = .notFound
        case .missingAppId: self = .missingAppId
        case .invalidAppId: self = .invalidAppId
        case .notAllowed: self = .notAllowed
        case .accessRestricted: self = .accessRestricted
        case .invalidBase: self = .invalidBase
        }
    }
}
