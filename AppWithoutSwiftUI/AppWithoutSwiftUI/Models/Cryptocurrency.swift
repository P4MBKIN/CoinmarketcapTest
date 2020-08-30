//
//  Cryptocurrency.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

struct Cryptocurrency: Decodable {
    let name: String
    let quote: Quote
}
