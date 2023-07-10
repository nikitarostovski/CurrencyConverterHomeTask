//
//  CurrencyService.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

/// Error that can be returned by `CurrencyService`
enum CurrencyServiceError: Error {
    case unableToGetData
}

protocol CurrencyServiceDelegate: AnyObject {
    /// Called after service's data is updated or new delegate set
    func currencyServiceDidUpdateData()
}

protocol CurrencyService: AnyObject {
    /// delegate's update methods will be called right after assign
    var delegate: CurrencyServiceDelegate? { get set }
    
    /// Currency selected as base for operations
    var selectedCurrency: CurrencyCode? { get set }
    
    /// Date when current data was
    var lastDataUpdateTime: Date? { get }
    
    /// Date when exchange data was created by someone (on server)
    var exchangeDataCreationTime: Date? { get }
    
    /// If `false`, data can not be updated again
    var retryAvailable: Bool { get }
    
    
    /// Converts money into all other currencies if possible
    /// - Parameter money: input money to convert
    /// - Returns: array of money in different currencies or error
    func convert(_ money: Money) async -> Result<[Money], CurrencyServiceError>
    
    /// Returns list of currencies available
    /// - Returns: list of currency codes or error
    func getAvailableCurrencies() async -> Result<[CurrencyCode], CurrencyServiceError>
    
    /// Returns a name for currency code
    /// - Parameter code: currency code ISO
    /// - Returns: name for currency with passed code
    func getCurrencyName(_ code: CurrencyCode) -> String?
    
    /// Tries to get fresh data if available
    func reloadDataIfAvailable()
}
