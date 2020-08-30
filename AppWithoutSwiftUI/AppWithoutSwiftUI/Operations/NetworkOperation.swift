//
//  NetworkOperation.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 30.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

class NetworkOperation<Model: Decodable>: Operation {
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    private(set) var model: Model?
    private(set) var error: Error?
    
    private let operationType: NetworkOperationTypes
    
    private var service: NetworkServiceProtocol?
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    required init(operationType: NetworkOperationTypes) {
        self.operationType = operationType
        super.init()
    }
    
    override func start() {
        if(self.isCancelled) {
            self.state = .finished
            return
        }
        
        self.state = .executing
        
        var params = [String: String]()
        switch self.operationType {
        case .authToken(let login, let password, let service):
            params["login"] = login
            params["password"] = password
            self.service = service
            
        case .cryptocurrencies(let token, let startOffset, let limit, let service):
            params["token"] = token
            params["startOffset"] = String(startOffset)
            params["limit"] = String(limit)
            self.service = service
        }
        
        self.service?.launchRequest(params: params) { [weak self] (model: Model?, error) in
            self?.error = error
            self?.model = model
            self?.state = .finished
        }
    }
    
    override func cancel() {
        self.service?.cancelAllRequests()
        super.cancel()
    }
}
