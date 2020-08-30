//
//  BaseRequest.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseRequest {
    
//    case authToken // Для реализации получения токена по логину паролю
    case cryptocurrencies // Для получения списка криптовалют
    
    func returnType(params: [String: String]?, addHeaders: [String: String]?) -> URLRequest {
        switch self {
        case .cryptocurrencies:
            var url = BaseUrl.init(scheme: .https, host: .coinmarketcapApi, path: .cryptocurrencies)
            
            var headers = [String: String]()
            let baseHeaders = BaseHeaders.cryptocurrencies.returnType()
            baseHeaders?.forEach {
                headers[$0.key] = $0.value
            }
            addHeaders?.forEach {
                headers[$0.key] = $0.value
            }
            
            let baseParams = BaseParams.cryptocurrencies.returnType()
            params?.forEach {
                url.queryParams.updateValue($0.value, forKey: $0.key)
            }
            baseParams?.forEach {
                url.queryParams.updateValue($0.value, forKey: $0.key)
            }
            
            var request = URLRequest(url: url.urlConfigList())
            request.httpMethod = BaseMethod.cryptocurrencies.rawValue
            request.allHTTPHeaderFields = headers
            return request
            
//        case .authToken:
//            var url = BaseUrl.init(scheme: .https, host: .coinmarketcapApi, path: .authToken)
//
//            var headers = [String: String]()
//            let baseHeaders = BaseHeaders.authToken.returnType()
//            baseHeaders?.forEach {
//                headers[$0.key] = $0.value
//            }
//            addHeaders?.forEach {
//                headers[$0.key] = $0.value
//            }
//
//            let baseParams = BaseParams.authToken.returnType()
//            params?.forEach {
//                url.queryParams.updateValue($0.value, forKey: $0.key)
//            }
//            baseParams?.forEach {
//                url.queryParams.updateValue($0.value, forKey: $0.key)
//            }
//
//            var request = URLRequest(url: url.urlConfigList())
//            request.httpMethod = BaseMethod.authToken.rawValue
//            request.allHTTPHeaderFields = headers
//            return request
        }
    }
}
