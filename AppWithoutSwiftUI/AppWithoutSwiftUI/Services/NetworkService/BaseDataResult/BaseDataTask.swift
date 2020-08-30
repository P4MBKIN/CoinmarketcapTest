//
//  BaseDataTask.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseDataTask {
    
//    case authToken // Для реализации получения токена по логину паролю
    case cryptocurrencies // Для получения списка криптовалют
    
    func dataTask(params: [String: String]?,
                  addHeaders: [String: String]?,
                  completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        switch self {
        case .cryptocurrencies:
            return configurateDataTask(
                request: BaseRequest.cryptocurrencies.returnType(params: params, addHeaders: addHeaders),
                session: BaseSession.main.returnType()) { (data, error) in
                    completion(data, error)
            }
            
//        case .authToken:
//            return configurateDataTask(
//                request: BaseRequest.authToken.returnType(params: params, addHeaders: addHeaders),
//                session: BaseSession.main.returnType()) { (data, error) in
//                    completion(data, error)
//            }
        }
    }
    
    private func configurateDataTask(request: URLRequest,
                                            session: URLSession,
                                            completion: @escaping (_ data: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return completion(nil, DataTaskError.nilDataError) }
            guard error == nil else { return completion(data, DataTaskError.requestError(error: error!)) }
            guard let res = response as? HTTPURLResponse else { return completion(data, DataTaskError.responseError) }
            guard (200...299).contains(res.statusCode) else { return completion(data, DataTaskError.serverError(status: res.statusCode)) }
            guard let mime = res.mimeType else { return completion(data, DataTaskError.getMineError) }
            guard mime == "application/json" else { return completion(data, DataTaskError.wrongMineError(mine: mime)) }
            
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
                completion(data, nil)
            } catch {
                completion(data, DataTaskError.jsonError(error: error.localizedDescription))
            }
        }
        return task
    }
}

enum DataTaskError: Error {
    case nilDataError
    case requestError(error: Error)
    case responseError
    case serverError(status: Int)
    case getMineError
    case wrongMineError(mine: String)
    case jsonError(error: String)
}

extension DataTaskError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .nilDataError: return "Получено пустое значение"
        case .requestError(let error): return "Ошибка в запросе: \(error)"
        case .responseError: return "Ошибка в отклике"
        case .serverError(let status): return "Ошибка от сервера: \(status)"
        case .getMineError: return "Не получен MIME тип"
        case .wrongMineError(let mine): return "Неправильный MIME тип: \(mine)"
        case .jsonError(let error): return "Ошибка JSON: \(error)"
        }
    }
}
