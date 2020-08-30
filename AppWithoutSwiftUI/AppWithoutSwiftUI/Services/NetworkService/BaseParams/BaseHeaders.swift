//
//  BaseHeaders.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseHeaders {
    
    case authToken // Выполнить получение токена, используя логин пароль
    case cryptocurrencies // Получить список криптовалюты
    
    func returnType() -> [String: String]? {
        var headers: [String: String]?
        
        switch self {
        case .authToken:
            headers = nil
        case .cryptocurrencies:
            headers?["Accepts"] = "application/json"
        }
        
        return headers
    }
}
