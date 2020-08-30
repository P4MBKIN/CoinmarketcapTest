//
//  Currency.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    
    let price: Double
    let percentChange1h: Double
    
    private enum CodingKeys: String, CodingKey {
        case price
        case percentChange1h = "percent_change_1h"
    }
}
