//
//  BaseUrlPath.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseUrlPath: String {
    case authToken = "" // Выполнить получение токена, используя логин пароль
    case cryptocurrencies = "/v1/cryptocurrency/listings/latest" // Получить список криптовалюты
}
