//
//  BaseMethod.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseMethod: String {
    case authToken = "POST" // Выполнить получение токена, используя логин пароль
    case cryptocurrencies = "GET" // Получить список криптовалюты
}
