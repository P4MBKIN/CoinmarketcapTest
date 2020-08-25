//
//  CryptocurrencyView.swift
//  AppWithSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import SwiftUI

struct CryptocurrencyView: View {
    
    let cryptocurrency: Cryptocurrency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5.0){
            Text(cryptocurrency.name)
                .font(.title)
            HStack(alignment: .center, spacing: 10.0){
                HStack {
                    Image(systemName: "dollarsign.circle")
                    Text(String(format: "%.8f", cryptocurrency.price))
                        .font(.subheadline)
                }
                Spacer()
                HStack {
                    if cryptocurrency.percentChange1h > 0 {
                        Image(systemName: "arrow.up").foregroundColor(.green)
                    } else if cryptocurrency.percentChange1h < 0 {
                        Image(systemName: "arrow.down").foregroundColor(.red)
                    }
                    Text(String(format: "%.8f", cryptocurrency.percentChange1h))
                }
            }
        }
        .padding()
    }
}

struct CryptocurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyView(cryptocurrency: Cryptocurrency(id: "1", name: "BTC", price: 9283.92, percentChange1h: -0.152774))
    }
}
