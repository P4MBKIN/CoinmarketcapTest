//
//  NetworkServiceProtocol.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 29.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol: class {
    func launchRequest<Model: Decodable>(params: [String: String]?, completion: @escaping ((Model?, Error?) -> Void))
    func cancelAllRequests()
}

protocol NetworkCryptocurrenciesServiceProtocol: NetworkServiceProtocol {}

/// Для реализации получения токена по логину паролю - заглушка
protocol NetworkAuthTokenServiceProtocol: NetworkServiceProtocol {}
