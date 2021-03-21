//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerViewDelegate: AnyObject {
    func didFailWithError(_ coinManager: CoinManager, error: Error)
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "EED6EA8D-6A60-4394-8D9F-1CAE1C8AD116"
    weak var delegate: CoinManagerViewDelegate?
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                self.delegate?.didFailWithError(self, error: err)
            }
            
            if let safeData = data {
                let rate = parseJSON(safeData) ?? 0.0
                self.delegate?.didUpdateCoin(self, coin: rate)
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData.rate
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

struct CoinData: Codable {
    let rate: Double
}
