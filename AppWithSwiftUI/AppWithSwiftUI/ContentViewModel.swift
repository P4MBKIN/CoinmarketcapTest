//
//  ContentViewModel.swift
//  AppWithSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import Foundation

final class ContentViewModel: ObservableObject {

    @Published private(set) var cryptocurrencies: [Cryptocurrency] = []
    @Published private(set) var pageIndex: Int = 0
    @Published private(set) var isNewPageLoading = false
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        refresh()
    }
    
    func refresh() {
        self.cryptocurrencies = []
        self.pageIndex = 0
    }
    
    func pageLoad(completion: (() -> Void)? = nil) {
        guard isNewPageLoading == false else { return }
        isNewPageLoading = true
        networkService.listingLatest(start: self.pageIndex * 30 + 1, limit: 30) { (list: CryptocurrencyList?, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("\(error)")
                    self.pageIndex -= 1
                } else {
                    self.cryptocurrencies.append(contentsOf: list?.cryptocurrencies ?? [])
                }
                self.isNewPageLoading = false
                if let completion = completion { completion() }
            }
        }
        self.pageIndex += 1
    }
}
