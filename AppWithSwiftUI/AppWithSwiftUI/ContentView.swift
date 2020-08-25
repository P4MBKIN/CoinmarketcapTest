//
//  ContentView.swift
//  AppWithSwiftUI
//
//  Created by Pavel on 24.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    @State private var isShowing = false
    
    var body: some View {
        VStack {
            List(contentViewModel.cryptocurrencies) { cryptocurrency in
                VStack(alignment: .leading) {
                    CryptocurrencyView(cryptocurrency: cryptocurrency)
                    if self.contentViewModel.isNewPageLoading && self.contentViewModel.cryptocurrencies.isLastItem(cryptocurrency) {
                        Divider()
                        Text("Loading...")
                    }
                }.onAppear {
                    self.onItemShowed(cryptocurrency)
                }
            }.onAppear() {
                self.contentViewModel.pageLoad()
            }.background(PullToRefresh(action: {
                self.contentViewModel.refresh()
                
                self.contentViewModel.pageLoad() {
                    self.isShowing = false
                }
            }, isShowing: $isShowing))
        }
    }
}

extension ContentView {
    private func onItemShowed<T: Identifiable>(_ item: T) {
        if self.contentViewModel.cryptocurrencies.isLastItem(item) {
            self.contentViewModel.pageLoad()
        }
    }
}

extension RandomAccessCollection where Self.Element: Identifiable {
    public func isLastItem<Item: Identifiable>(_ item: Item) -> Bool {
        guard !isEmpty else {
            return false
        }
        
        guard let itemIndex = lastIndex(where: { AnyHashable($0.id) == AnyHashable(item.id) }) else {
            return false
        }
        
        let distance = self.distance(from: itemIndex, to: endIndex)
        return distance == 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ContentViewModel(networkService: NetworkService()))
    }
}
