//
//  CombinedSourceCurrencyService.swift
//  CurrencyConverter
//
//  Created by Rost on 16.06.2023.
//

import Foundation

/// Service, that can both store exchange data locally and download it from server
final class CombinedSourceCurrencyService: CurrencyService {
    /// Exchange rates update mode
    enum DataUpdateMode {
        /// Automatic updates every amount of time passed in `timeBetweenRequests`
        case auto
        /// Try to update only when asked manually
        case manual
    }
    
    private let timeBetweenRequests: TimeInterval
    private let apiService: OpenExchangeRatesAPIService
    private let storageService: PersistentStorageService
    private let dataUpdateMode: DataUpdateMode
    
    private var exchangeData: ExchangeData?
    private var requestInProgress = false
    
    private var allCurrencies: [CurrencyCode]? {
        exchangeData?.allCurrencies
    }
    
    private var timeSinceLastUpdate: TimeInterval? {
        guard let createDate = exchangeData?.createDate else { return nil }
        return Date().timeIntervalSince(createDate)
    }
    
    private var canTryToUpdate: Bool {
        guard !requestInProgress else { return false }
        guard let _ = exchangeData, let timeSinceLastUpdate = timeSinceLastUpdate else { return true }
        return timeSinceLastUpdate > timeBetweenRequests
    }
    
    weak var delegate: CurrencyServiceDelegate? {
        didSet {
            delegate?.currencyServiceDidUpdateData()
        }
    }
    
    var retryAvailable: Bool {
        !requestInProgress
    }
    
    var lastDataUpdateTime: Date? {
        exchangeData?.createDate
    }
    
    var exchangeDataCreationTime: Date? {
        exchangeData?.timestamp
    }
    
    var selectedCurrency: CurrencyCode? {
        didSet {
            if let newValue = selectedCurrency, newValue != oldValue {
                storageService.saveSelectedCurrency(newValue)
                if dataUpdateMode == .manual {
                    reloadDataIfAvailable()
                }
            }
        }
    }
    
    init(apiService: OpenExchangeRatesAPIService,
         storageService: PersistentStorageService,
         delegate: CurrencyServiceDelegate? = nil,
         timeBetweenRequests: TimeInterval,
         dataUpdateMode: DataUpdateMode) {
        
        self.dataUpdateMode = dataUpdateMode
        self.timeBetweenRequests = timeBetweenRequests
        self.apiService = apiService
        self.storageService = storageService
        self.delegate = delegate
        
        self.selectedCurrency = storageService.loadSelectedCurrency()
        self.exchangeData = try? storageService.loadLastExchangeData()
        
        switch dataUpdateMode {
        case .auto:
            Timer.scheduledTimer(withTimeInterval: timeBetweenRequests, repeats: true) { _ in
                self.reloadDataIfAvailable()
            }
        case .manual:
            break
        }
        
        Task {
            await reloadExchangeData()
        }
    }
    
    func reloadDataIfAvailable() {
        guard canTryToUpdate else { return }
        Task {
            await reloadExchangeData(shouldNotifyDelegate: true)
        }
    }
    
    func getCurrencyName(_ code: CurrencyCode) -> String? {
        exchangeData?.getCurrencyName(code)
    }
    
    func convert(_ money: Money) async -> Result<[Money], CurrencyServiceError> {
        guard let exchangeData = exchangeData else {
            return .failure(.unableToGetData)
        }
        let result = exchangeData.convert(money)
        return .success(result)
    }
    
    func getAvailableCurrencies() async -> Result<[CurrencyCode], CurrencyServiceError> {
        guard let _ = exchangeData else {
            return .failure(.unableToGetData)
        }
        if let allCurrencies = allCurrencies {
            return .success(allCurrencies)
        } else {
            return .failure(.unableToGetData)
        }
    }
    
    private func reloadExchangeData(shouldNotifyDelegate: Bool = true, forceLoadFromDisk: Bool = false) async {
        guard !requestInProgress else {
            return
        }
        requestInProgress = true
        if !forceLoadFromDisk {
            self.exchangeData = try? await apiService.getExchangeData()
        }
        
        // Add currency name data
        if !forceLoadFromDisk, let currencyNames = try? await apiService.getAvailableCurrencyNames() {
            self.exchangeData?.addCurrencyNames(currencyNames)
        }
        
        if let exchangeData = self.exchangeData {
            try? await self.storageService.saveCurrentExchangeData(exchangeData)
        } else {
            self.exchangeData = try? self.storageService.loadLastExchangeData()
        }
        
        requestInProgress = false
        
        guard shouldNotifyDelegate else { return }
        await MainActor.run {
            self.delegate?.currencyServiceDidUpdateData()
        }
    }
}
