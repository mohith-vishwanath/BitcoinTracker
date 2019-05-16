//
//  ViewController.swift
//  testingApp
//
//  Created by Mohith on 14/05/19.
//  Copyright © 2019 Mohith. All rights reserved.
//


import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SVProgressHUD

/*

Make sure you've all the necessary pods installed. For this project, I've used Alamofire, SwiftyJSON, and SVProgressHUD
Web API used : https://apiv2.bitcoinaverage.com
*/

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getPrice(baseURL, currency,0)
        
    }
    
    //The number of rows inside each column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    //The data for each row within a column
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    //The number of columns in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected currency : \(currencyArray[row])")
        currency = currencyArray[row]
        
        priceLabel.font = UIFont(name: "Kefa", size: 30)
        getPrice(baseURL, currency,row)
    }
    
    
    //Variables used
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    var currency = "USD"
    
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪","₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    //NETWORKING
    func getPrice(_ url : String, _ selectedCurrency : String, _ row : Int) {
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.show(withStatus: "Getting data...")
        
        let finalURL = url + selectedCurrency
        
        Alamofire.request(finalURL, method: .get, parameters: nil).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success! Got the price data")
                print(response.result.value!)
                
                let priceJSON = JSON(response.result.value!)
                self.updateUIElements(priceJSON, row)
            }else{
                print("Failure! Couldn't get the data")
                
                self.highPriceLabel.text = "0.00"
                self.lowPriceLabel.text = "0.00"
                self.priceLabel.font = UIFont(name: "Kefa", size: 18)
                self.priceLabel.text = "Connection error"
                SVProgressHUD.dismiss()
            }
        }
        
    }
    
    
    //UPDATE THE UI ELEMENTS
    func updateUIElements(_ responseJSON : JSON, _ row : Int) {
        
        priceLabel.text = "\(currencySymbols[row])\(String(format: "%.2f",responseJSON["last"].doubleValue))"
        highPriceLabel.text = "\(currencySymbols[row])\(String(format: "%.2f",responseJSON["high"].doubleValue))"
        lowPriceLabel.text = "\(currencySymbols[row])\(String(format: "%.2f",responseJSON["low"].doubleValue))"
        
        
          SVProgressHUD.dismiss()
        
    }
    
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var highPriceLabel: UILabel!
    @IBOutlet weak var lowPriceLabel: UILabel!
    
}

