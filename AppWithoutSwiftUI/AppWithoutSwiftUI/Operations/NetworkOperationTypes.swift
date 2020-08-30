//
//  NetworkOperationTypes.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum NetworkOperationTypes {
    case authToken(login: String, password: String, service: NetworkAuthTokenServiceProtocol)
    case cryptocurrencies(token: String, startOffset: Int, limit: Int, service: NetworkCryptocurrenciesServiceProtocol)
}
