//
//  BaseParams.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseParams {
    
    case authToken // Выполнить получение токена, используя логин пароль
    case cryptocurrencies // Получить список криптовалюты
    
    func returnType() -> [String: String]? {
        var params: [String: String]?
        
        switch self {
        case .authToken:
            params = nil
        case .cryptocurrencies:
            params = [String: String]()
            params?["convert"] = "USD" // Для получения курса в долларах
        }
        
        return params
    }
}
