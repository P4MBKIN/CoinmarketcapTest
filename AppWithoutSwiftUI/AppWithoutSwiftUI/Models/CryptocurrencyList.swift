//
//  CryptocurrencyList.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct CryptocurrencyList: Decodable {
    
    let cryptocurrencies: [Cryptocurrency]?
    let status: CryptocurrencyStatus
    
    private enum CodingKeys: String, CodingKey {
        case cryptocurrencies = "data"
        case status
    }
}
