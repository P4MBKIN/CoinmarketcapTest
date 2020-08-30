//
//  CryptocurrencyStatus.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct CryptocurrencyStatus: Decodable {
    
    let errorCode: Int
    let errorMessage: String?
    
    private enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_message"
    }
}
