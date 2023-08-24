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
    var cpiDataArray: [[Any]] = [[]]

    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var baseSpendTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.isHidden = true
        
        baseSpendTextField.delegate = self
        baseSpendTextField.placeholder = "Pre-tax spending in base year"
        
        retrieveParseData.delegate = self
        retrieveParseData.fetchData()
        
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        self.baseSpend = Int(baseSpendTextField.text ?? "Error")
        
        if let baseYear = self.selectedYear, let baseSpend = self.baseSpend {
            print("The base year is \(baseYear).")
            let yearsSinceBase = self.cpiDataArray[0][0] as! Int - baseYear
            let eggroCalcs = self.eggroCalcBrain.performCalcs(cpiDataArray: cpiDataArray, baseYear: baseYear, baseSpend: baseSpend)
            
            print("The most recently available data is from \(cpiDataArray[0][2]) \(cpiDataArray[0][0]).")
            
            print("Pre-tax spending in \(baseYear) was $\(baseSpend.withCommas()).")
            
            print("Inflation since \(cpiDataArray[12 * yearsSinceBase][2]) \(cpiDataArray[12 * yearsSinceBase][0]) is \(String(format: "%.2f", (eggroCalcs.infAdj)))%.")
            
            print("The inflation adjusted spend is $\(eggroCalcs.infAdjSpend.withCommas()).")
            
            print("The inflation adjusted spend is $\(eggroCalcs.infAdjSpend.withCommas()).")
            
            print("Base Year Target Investments (4% Withdrawal) = $\(eggroCalcs.baseTargetInvLow.withCommas()).")
            
            print("Base Year Target Investments (3% Withdrawal) = $\(eggroCalcs.baseTargetInvHigh.withCommas()).")
            
            print("Inflation Adjusted Target Investments (4% Withdrawal) = $\(eggroCalcs.infAdjTargetInvLow.withCommas()).")
            
            print("Inflation Adjusted Target Investments (3% Withdrawal) = $\(eggroCalcs.infAdjTargetInvHigh.withCommas()).")
            
        }
        
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
        return selectedYear = self.yearArray[row]
    }

    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    func didRetrieveParseData(dataArray: [[Any]]) {
        
        self.cpiDataArray = dataArray
        self.yearArray = ((dataArray[0][0] as! Int - 10)...(dataArray[0][0] as! Int)).map { $0 }
        
        DispatchQueue.main.async {
            
            self.yearPicker.isHidden = false
            self.yearPicker.reloadAllComponents()
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if baseSpendTextField.text != "" {
            self.view.endEditing(true)
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if baseSpendTextField.text != "" {
            self.view.endEditing(true)
            return true
        } else {
            return false
        }
    }
}
    

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


