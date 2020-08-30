//
//  NetworkCryptocurrenciesService.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

class NetworkCryptocurrenciesService: NetworkCryptocurrenciesServiceProtocol {
    
    private var tasks: [URLSessionDataTask] = []
    
    func launchRequest<Model: Decodable>(params: [String: String]?, completion: @escaping ((Model?, Error?) -> Void)) {
        var requestHeaders = [String: String]()
        requestHeaders["X-CMC_PRO_API_KEY"] = params?["token"]
        
        var requestParams = [String: String]()
        requestParams["start"] = params?["startOffset"]
        requestParams["limit"] = params?["limit"]
        
        let task = BaseDataTask.cryptocurrencies.dataTask(params: requestParams, addHeaders: requestHeaders) { (data, error) in
            if let error = error { return completion(nil, error) }
            guard let data = data else { return completion(nil, BaseResultError.nilDataError) }
            
            let (model, parseError): (Model?, Error?) = parseJson(data: data)
            if model != nil { return completion(model, nil) }
            else { return completion(nil, parseError) }
        }
        
        self.tasks.append(task)
        task.resume()
    }
    
    func cancelAllRequests() {
        self.tasks.forEach { task in
            task.cancel()
        }
    }
}
