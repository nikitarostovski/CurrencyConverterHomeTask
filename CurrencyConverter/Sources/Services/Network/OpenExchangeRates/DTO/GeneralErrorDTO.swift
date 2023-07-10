//
//  GeneralErrorDTO.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

struct GeneralErrorDTO: Codable {
    enum Message: String, Codable {
        case notFound = "not_found"
        case missingAppId = "missing_app_id"
        case invalidAppId = "invalid_app_id"
        case notAllowed = "not_allowed"
        case accessRestricted = "access_restricted"
        case invalidBase = "invalid_base"
    }
    
    let error: Bool
    let status: Int
    let description: String?
    let message: Message
}
