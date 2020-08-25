//
//  ViewController.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cryptocurrencyTableView: UITableView!
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    private var cryptocurrencies: [Cryptocurrency] = []
    private var pageIndex: Int = 0
    private var isNewPageLoading = false
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        self.cryptocurrencyTableView.refreshControl = self.refreshControl
        pageLoad()
    }
    
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        refresh()
    }
    
    func refresh() {
        self.cryptocurrencies = []
        self.pageIndex = 0
        self.cryptocurrencyTableView.reloadData()
        pageLoad()
    }
    
    func pageLoad() {
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
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                self.cryptocurrencyTableView.reloadData()
            }
        }
        self.pageIndex += 1
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cryptocurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.cryptocurrencies.indices.contains(indexPath.row) else { return UITableViewCell() }
        let cell = self.cryptocurrencyTableView.dequeueReusableCell(withIdentifier: CryptocurrencyTableViewCell.reuseID) as? CryptocurrencyTableViewCell
        guard let cryptocurrencyCell = cell else { return UITableViewCell() }
        cryptocurrencyCell.set(cryptocurrency: self.cryptocurrencies[indexPath.row])
        return cryptocurrencyCell
    }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            pageLoad()
        }
    }
}
