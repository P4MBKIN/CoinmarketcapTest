//
//  Quote.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct Quote: Decodable {
    
    let usd: Currency
    
    private enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}
