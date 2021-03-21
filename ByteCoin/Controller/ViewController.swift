//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
// MARK: - IBOutlets
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencylabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
// MARK: - Variables
    var coinManager = CoinManager()
    var currencySelected = ""

// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        coinManager.delegate = self
    }
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.getCoinPrice(for: coinManager.currencyArray[row])
        currencySelected = coinManager.currencyArray[row]
    }
}

// MARK: - CoinManagerViewDelegate
extension ViewController: CoinManagerViewDelegate {
    func didFailWithError(_ coinManager: CoinManager, error: Error) {
        print(error.localizedDescription)
    }
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.3f", coin)
            self.currencylabel.text = self.currencySelected
        }
    }
    
    
}
