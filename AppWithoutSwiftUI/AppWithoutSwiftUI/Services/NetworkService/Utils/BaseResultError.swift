//
//  BaseResultError.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

enum BaseResultError: Error {
    case nilDataError
}

extension BaseResultError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .nilDataError: return "Получено пустое значение"
        }
    }
}
