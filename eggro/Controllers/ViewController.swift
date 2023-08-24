//
//  ViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {

    var retrieveParseData = RetrieveParseData()
    var eggroCalcBrain = EggroCalcBrain()
    var baseYear: Int?
    var selectedYear: Int?
    var baseSpend: Int?
    var yearArray: [Int] = []

    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var baseSpendTextField: UITextField!
    
    @IBOutlet weak var infAdjSpendLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.isHidden = true
        retrieveParseData.delegate = self
        retrieveParseData.fetchData()
    }
}


extension ViewController: RetrieveParseDataDelegate, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.yearArray[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedYear = self.yearArray[row]
//        coinManager.getCoinPrice(cryptoType: "BTC", currency: selectedCurrency)
    }

    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    func didRetrieveParseData(dataArray: [[Any]]) {
        
        self.yearArray = ((dataArray[0][0] as! Int - 10)...(dataArray[0][0] as! Int)).map { $0 }
        
        baseYear = 2017
        baseSpend = 70000
        
        DispatchQueue.main.async {

            self.yearPicker.isHidden = false
            self.yearPicker.reloadAllComponents()

            if let baseYear = self.baseYear, let baseSpend = self.baseSpend {
                
                let yearsSinceBase = dataArray[0][0] as! Int - baseYear
                let eggroCalcs = self.eggroCalcBrain.performCalcs(cpiDataArray: dataArray, baseYear: baseYear, baseSpend: baseSpend)
                
                print("The most recently available data is from \(dataArray[0][2]) \(dataArray[0][0]).")
                
                print("Pre-tax spending in \(baseYear) was $\(baseSpend.withCommas()).")
                
                print("Inflation since \(dataArray[12 * yearsSinceBase][2]) \(dataArray[12 * yearsSinceBase][0]) is \(String(format: "%.2f", (eggroCalcs.infAdj)))%.")
                
                print("The inflation adjusted spend is $\(eggroCalcs.infAdjSpend.withCommas()).")
                
                self.infAdjSpendLabel.text = String("The inflation adjusted spend is $\(eggroCalcs.infAdjSpend.withCommas()).")
                
                print("Base Year Target Investments (4% Withdrawal) = $\(eggroCalcs.baseTargetInvLow.withCommas()).")
                
                print("Base Year Target Investments (3% Withdrawal) = $\(eggroCalcs.baseTargetInvHigh.withCommas()).")
                
                print("Inflation Adjusted Target Investments (4% Withdrawal) = $\(eggroCalcs.infAdjTargetInvLow.withCommas()).")
                
                print("Inflation Adjusted Target Investments (3% Withdrawal) = $\(eggroCalcs.infAdjTargetInvHigh.withCommas()).")
                
            }
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        baseSpendTextField.endEditing(true)
        return true
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let baseSpend = baseSpendTextField.text {
/*            let cityWithNoSpaces: String = city.replacingOccurrences(of: " ", with: "%20")
            weatherManager.fetchWeather(cityName: cityWithNoSpaces)
 */
        }
        baseSpendTextField.text = "Pre-tax spending in base year"
    }
    
}

/*
 extension ViewController: UITextFieldDelegate {
     
     @IBAction func searchPressed(_ sender: UIButton) {
         searchTextField.endEditing(true)
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
         return true
     }
     
     func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
         if textField.text != "" {
             textField.placeholder = "Search for a City"
             return true
         } else {
             textField.placeholder = "Enter a City Name"
             return false
         }
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         if let city = searchTextField.text {
             let cityWithNoSpaces: String = city.replacingOccurrences(of: " ", with: "%20")
             weatherManager.fetchWeather(cityName: cityWithNoSpaces)
         }
         searchTextField.text = ""
     }
 }
 */

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
