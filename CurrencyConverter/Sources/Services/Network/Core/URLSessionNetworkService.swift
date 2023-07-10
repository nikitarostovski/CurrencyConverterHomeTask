//
//  URLSessionNetworkService.swift
//  CurrencyConverter
//
//  Created by Rost on 14.06.2023.
//

import Foundation

///  `URLSession`-based implementation of `NetwokService` protocol
public actor URLSessionNetworkService: NetworkService {
    let defaultURLParams: [String: String]
    let defaultHeaders = [String: String]()
    
    private let logger: URLSessionNetworkLogger?
    private var session: URLSession
    private let baseURL: BaseURL
    
    public init(baseURL: BaseURL, defaultURLParams: [String: String] = [:], loggingEnabled: Bool = true) {
        self.logger = loggingEnabled ? URLSessionNetworkLogger() : nil
        self.baseURL = baseURL
        self.defaultURLParams = defaultURLParams
        self.session = URLSession(configuration: .default)
    }
    
    public func request(_ request: NetworkRequest) async throws -> NetworkResponse {
        let allHeaders = defaultHeaders.merging(request.headers) { (_, new) in new }
        let allParams = defaultURLParams.merging(request.endpoint.urlParams) { (_, new) in new }
        
        let url = baseURL.url
            .appending(path: request.endpoint.path)
            .appending(queryItems: allParams.map { URLQueryItem(name: $0, value: $1) })
        
        do {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.httpMethod.rawValue
            urlRequest.allHTTPHeaderFields = allHeaders
            
            let (data, response) = try await session.data(for: urlRequest)
            guard let response = response as? HTTPURLResponse else {
                let error = CommonEndpointError.unknown
                logger?.log(request: urlRequest, response: nil, data: data, error: error)
                throw error
            }
            
            logger?.log(request: urlRequest, response: response, data: data, error: nil)
            
            return NetworkResponse(httpCode: response.statusCode, payload: data)
        } catch {
            throw error
        }
    }
}
