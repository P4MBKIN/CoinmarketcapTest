//
//  NetworkService.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: class {
    func listingLatest<Model: Decodable>(start: Int, limit: Int, completion: @escaping (Model?, Error?) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func listingLatest<Model: Decodable>(start: Int, limit: Int, completion: @escaping (Model?, Error?) -> Void) {
        var params = [String: String]()
        params["start"] = String(start)
        params["limit"] = String(limit)
        params["convert"] = "USD"
        
        var headers = [String: String]()
        headers["Accepts"] = "application/json"
        headers["X-CMC_PRO_API_KEY"] = "0882fc64-7ea2-4628-bf4c-b0f28aedd6c2"
        
        var url = BaseUrl(scheme: "https", host: "pro-api.coinmarketcap.com", path: "/v1/cryptocurrency/listings/latest", params: params)
        var request = URLRequest(url: url.urlConfigList())
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = 60
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return completion(nil, NSError(domain: "", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Data is nil"])) }
            guard error == nil else { return completion(nil, error) }
            guard let res = response as? HTTPURLResponse else { return completion(nil, NSError(domain: "", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Response error"])) }
            guard (200...299).contains(res.statusCode) else { return completion(nil, NSError(domain: "", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Server error: \(res.statusCode)"])) }
            guard let mime = res.mimeType else { return completion(nil, NSError(domain: "", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Could not get MIME type"])) }
            guard mime == "application/json" else { return completion(nil, NSError(domain: "", code: -1, userInfo: [ NSLocalizedDescriptionKey: "Wrong MIME type: \(mime)"])) }
            
            let (model, parseError): (Model?, Error?) = parseJson(data: data)
            if model != nil { return completion(model, nil) }
            else { return completion(nil, parseError) }
        }
        task.resume()
    }
}

struct BaseUrl {
    
    let scheme: String
    let host: String
    let path: String?
    let params: [String: String]
    
    var urlComponents = URLComponents()
    
    mutating func urlConfigList() -> URL {
        self.urlComponents.scheme = self.scheme
        self.urlComponents.host = self.host
        self.urlComponents.path = self.path ?? ""
        self.urlComponents.setQueryItems(with: self.params)
        guard let url = self.urlComponents.url else { fatalError("Could not create URL from components") }
        return url
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value) }
    }
}

private func parseJson<T: Decodable>(data: Data) -> (T?, Error?) {
    var model: T?
    var error: Error?
    do {
        let decoder = JSONDecoder()
        model = try decoder.decode(T.self, from: data)
    } catch DecodingError.dataCorrupted(let context) {
        error = DecodingError.dataCorrupted(context)
    } catch DecodingError.keyNotFound(let key, let context) {
        error = DecodingError.keyNotFound(key,context)
    } catch DecodingError.typeMismatch(let type, let context) {
        error = DecodingError.typeMismatch(type,context)
    } catch DecodingError.valueNotFound(let value, let context) {
        error = DecodingError.valueNotFound(value,context)
    } catch let jsonError{
        error = jsonError
    }
    return (model, error)
}
