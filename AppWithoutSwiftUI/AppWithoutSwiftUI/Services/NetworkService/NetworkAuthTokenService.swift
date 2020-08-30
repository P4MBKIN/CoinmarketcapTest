//
//  NetworkAuthTokenService.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

/// mock-структура для токена
struct AuthTokenMock: Encodable {
    let token: String
}

class NetworkAuthTokenService: NetworkAuthTokenServiceProtocol {
    
    private var operations: [Operation] = []
    
    /// mock для получения токена по логину-паролю
    func launchRequest<Model: Decodable>(params: [String: String]?, completion: @escaping ((Model?, Error?) -> Void)) {
        guard let data = try? JSONEncoder().encode(AuthTokenMock(token: "0882fc64-7ea2-4628-bf4c-b0f28aedd6c2")) else {
            return completion(nil, BaseResultError.nilDataError)
        }
        
        let blockOperation = BlockOperation {
            let (model, parseError): (Model?, Error?) = parseJson(data: data)
            if model != nil { return completion(model, nil) }
            else { return completion(nil, parseError) }
        }
        self.operations.append(blockOperation)

        let queue = OperationQueue()
        queue.qualityOfService = .utility
        queue.addOperation(blockOperation)
    }
    
    func cancelAllRequests() {
        self.operations.forEach { operation in
            operation.cancel()
        }
    }
}
