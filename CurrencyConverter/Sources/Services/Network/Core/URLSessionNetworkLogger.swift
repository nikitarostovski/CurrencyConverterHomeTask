//
//  URLSessionNetworkLogger.swift
//  CurrencyConverter
//
//  Created by Rost on 15.06.2023.
//

import Foundation

/// Class for logging network events in debug purposes
public final class URLSessionNetworkLogger {
    private let prefix = "[NETWORK]"
    
    func log(request: URLRequest, response: HTTPURLResponse?, data: Data?, error: Error?) {
        let method = request.httpMethod ?? "UNKNOWN_METHOD"
        let url = request.url?.absoluteString ?? ""
        print("\n\(prefix) \(method) \(url)")
        
        var requestParams = ""
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            requestParams += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            requestParams += "\n\(String(data: body, encoding: .utf8) ?? "")"
        }
        print(requestParams)
        
        if let error = error {
            print("\(prefix) Error: \"\(error)\"")
            return
        }
        
        print("\(prefix) Status code: \(response?.statusCode ?? -1)")
        var responseParams = ""
        for (key, value) in response?.allHeaderFields ?? [:] {
            responseParams += "\(key): \(value)\n"
        }
        if let body = data {
            responseParams += "\n\(String(data: body, encoding: .utf8) ?? "")\n"
        }
        print(responseParams)
    }
}
