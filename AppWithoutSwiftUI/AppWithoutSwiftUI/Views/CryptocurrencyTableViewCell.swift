//
//  CryptocurrencyTableViewCell.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import UIKit

class CryptocurrencyTableViewCell: UITableViewCell {
    
    static let reuseID = "CryptocurrencyTableViewCell"
    
    // MARK:- UI Elements
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var percentChange1hLabel: UILabel!
    
    // MARK:- Interface
    func set(cryptocurrency: Cryptocurrency) {
        self.nameLabel.text = cryptocurrency.name
        self.priceLabel.text = String(format: "%.8f", cryptocurrency.quote.usd.price)
        if cryptocurrency.quote.usd.percentChange1h > 0 {
            self.arrowImage.image = UIImage(systemName: "arrow.up")
            self.arrowImage.tintColor = .green
        } else {
            self.arrowImage.image = UIImage(systemName: "arrow.down")
            self.arrowImage.tintColor = .red
        }
        self.percentChange1hLabel.text = String(format: "%.8f", cryptocurrency.quote.usd.percentChange1h)
    }
}
