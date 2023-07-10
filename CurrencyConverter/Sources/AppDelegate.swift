//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Rost on 13.06.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private struct Constants {
        static let basePath = URL(string: "https://openexchangerates.org/api/")!
        static let appID = "025121d6d17f489abbc800c89fcf8138"
        static let minimumTimeBetweenRequests: TimeInterval = 30 * 60
        static let automaticUpdates = true
    }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let isRunningTests = NSClassFromString("XCTestCase") != nil
        guard !isRunningTests else { return true }
        
        let currencyService = makeCurrencyService()
        let root = MainBuilder.build(currencyService: currencyService)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .systemMint
        window.rootViewController = root
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    private func makeCurrencyService() -> CurrencyService {
        let networkService = makeNetworkService()
        let apiService = OpenExchangeRatesAPIService(networkService: networkService, appID: Constants.appID)
        let storageService = PersistentStorageService(storage: Storage(), userDefaults: .standard)
        let dataUpdateMode: CombinedSourceCurrencyService.DataUpdateMode = Constants.automaticUpdates ? .auto : .manual
        
        return CombinedSourceCurrencyService(apiService: apiService,
                                             storageService: storageService,
                                             timeBetweenRequests: Constants.minimumTimeBetweenRequests,
                                             dataUpdateMode: dataUpdateMode)
    }
    
    private func makeNetworkService() -> NetworkService {
        let baseURL = BaseURL(url: Constants.basePath)
        let networkService = URLSessionNetworkService(baseURL: baseURL)
        return networkService
    }
}
