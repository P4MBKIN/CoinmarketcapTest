//
//  ViewController.swift
//  AppWithoutSwiftUI
//
//  Created by Pavel on 25.08.2020.
//  Copyright © 2020 b2broker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK:- UI Elements
    @IBOutlet weak var cryptocurrencyTableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK:- Services
    /// Лучше всего делать инъекцию этих сервисов в конструкторе (если в проекте используется вестка в коде, а не storyboad'ы или xib'ы)
    private let cryptocurrenciesService: NetworkCryptocurrenciesServiceProtocol = NetworkCryptocurrenciesService()
    private let authTokenService: NetworkAuthTokenServiceProtocol = NetworkAuthTokenService()
    
    // MARK:- View Controller State
    private var state: ViewControllerState = .notToken {
        didSet {
            if self.state == .emptyCryptocurrencies {
                OperationQueue.main.addOperation { [unowned self] in
                    self.downloadPageContent()
                }
            }
        }
    }
    
    // MARK:- Download Cryptocurrencies parameters
    private var parameters: DownloadParameters?
    
    
    // MARK:- Content
    private var cryptocurrencies: [Cryptocurrency] = [] {
        didSet {
            OperationQueue.main.addOperation { [unowned self] in
                self.state = .readyDownload
                self.refreshControl.endRefreshing()
                self.cryptocurrencyTableView.reloadData()
            }
        }
    }
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK:- Setup View Controller
    private func setup() {
        setupUi()
        setupParameters()
    }
    
    private func setupUi() {
        self.refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(sender:)), for: .valueChanged)
        self.cryptocurrencyTableView.refreshControl = self.refreshControl
    }
    
    private func setupParameters() {
        /// Обычно токен получаем из БД или с предудущего экрана (через зависимость в конструктуре) или UserDefaults (плохой вариант), в данном же случае симитируем получение по сети
        let operationType: NetworkOperationTypes = .authToken(login: "loginTest", password: "passwordTest", service: self.authTokenService)
        let operation: NetworkOperation<AuthToken> = NetworkOperation(operationType: operationType)
        operation.completionBlock = { [weak self] in
            if let error = operation.error {
                print("Get token error: \(error.localizedDescription)")
                return
            }
            guard let token = operation.model?.token else { return }
            
            /// TODO: значения параметров limit и currentOffset должны считываться из БД или UserDefaults (здесь захардкожены!)
            self?.parameters = DownloadParameters(token: token, limit: 30, currentOffset: 1)
            
            self?.state = .emptyCryptocurrencies
        }
        
        OperationQueue.current?.addOperation(operation)
    }
    
    // MARK:- Content manipulations
    private func refresh() {
        self.parameters?.currentOffset = 1
        self.cryptocurrencies = []
        self.state = .emptyCryptocurrencies
    }
    
    private func downloadPageContent() {
        guard self.state != .downloading, let params = self.parameters else { return }
        
        self.state = .downloading
        
        let operationType: NetworkOperationTypes = .cryptocurrencies(token: params.token,
                                                                     startOffset: params.currentOffset,
                                                                     limit: params.limit,
                                                                     service: self.cryptocurrenciesService)
        let operation: NetworkOperation<CryptocurrencyList> = NetworkOperation(operationType: operationType)
        operation.completionBlock = { [weak self] in
            if let error = operation.error {
                print("Get cryptocurrencies error: \(error.localizedDescription)")
                return
            }
            self?.cryptocurrencies.append(contentsOf: operation.model?.cryptocurrencies ?? [])
            self?.parameters?.currentOffset = (self?.cryptocurrencies.count ?? 0) + 1
            self?.state = .readyDownload
        }
        OperationQueue.main.addOperation(operation)
    }
    
    // MARK:- Views events
    @objc private func refreshControlValueChanged(sender: UIRefreshControl) {
        refresh()
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
        if distanceFromBottom < height { downloadPageContent() }
    }
}
