//
//  Cryptocurrency.swift
//  AppWithSwiftUI
//
//  Created by Pavel on 24.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct Cryptocurrency: Decodable, Identifiable {
    
    let id: String
    let name: String
    let price: Double
    let percentChange1h: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case quote
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try String(container.decode(Int.self, forKey: .id))
        self.name = try container.decode(String.self, forKey: .name)
        let quote = try container.decode(Quote.self, forKey: .quote)
        self.price = quote.usd.price
        self.percentChange1h = quote.usd.percentChange1h
    }
    
    init(id: String, name: String, price: Double, percentChange1h: Double) {
        self.id = id
        self.name = name
        self.price = price
        self.percentChange1h = percentChange1h
    }
}

struct CryptocurrencyList: Decodable {
    
    let cryptocurrencies: [Cryptocurrency]?
    let status: CryptocurrencyStatus
    
    enum CodingKeys: String, CodingKey {
        case data
        case status
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if container.contains(.data) {
            self.cryptocurrencies = try container.decode([Cryptocurrency]?.self, forKey: .data)
        } else {
            self.cryptocurrencies = nil
        }
        self.status = try container.decode(CryptocurrencyStatus.self, forKey: .status)
    }
}

struct CryptocurrencyStatus: Decodable {
    
    let errorCode: Int
    let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case error_code
        case error_message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorCode = try container.decode(Int.self, forKey: .error_code)
        self.errorMessage = try container.decode(String?.self, forKey: .error_message)
    }
}

private struct Quote: Decodable {
    
    let usd: Currency
    
    enum CodingKeys: String, CodingKey {
        case USD
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.usd = try container.decode(Currency.self, forKey: .USD)
    }
}

private struct Currency: Decodable {
    
    let price: Double
    let percentChange1h: Double
    
    enum CodingKeys: String, CodingKey {
        case price
        case percent_change_1h
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Double.self, forKey: .price)
        self.percentChange1h = try container.decode(Double.self, forKey: .percent_change_1h)
    }
}
