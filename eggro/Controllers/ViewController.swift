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
    var mostRecentMonth: String?
    var mostRecentYear: Int?
    var baseYear: Int?
    var selectedYear: Int?
    var baseSpend: Int?
    var yearArray: [Int] = []
    var cpiDataArray: [[Any]] = [[]]
    var eggroCalcs: (infAdj: Double?, infAdjSpend: Int?, baseTargetInvLow: Int?, baseTargetInvHigh: Int?, infAdjTargetInvLow: Int?, infAdjTargetInvHigh: Int?)

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

            self.mostRecentMonth = self.cpiDataArray[0][2] as? String
            self.mostRecentYear = self.cpiDataArray[0][0] as? Int
            
            self.baseYear = baseYear
                        
            self.eggroCalcs = self.eggroCalcBrain.performCalcs(cpiDataArray: cpiDataArray, baseYear: baseYear, baseSpend: baseSpend)
            
            self.performSegue(withIdentifier: "goToResults", sender: self)
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.mostRecentMonth = self.mostRecentMonth
            destinationVC.mostRecentYear = self.mostRecentYear
            destinationVC.baseYear = self.baseYear
            destinationVC.baseSpend = self.baseSpend
            destinationVC.infAdj = self.eggroCalcs.infAdj
            destinationVC.infAdjSpend = self.eggroCalcs.infAdjSpend
            destinationVC.baseTargetInvLow = self.eggroCalcs.baseTargetInvLow
            destinationVC.baseTargetInvHigh = self.eggroCalcs.baseTargetInvHigh
            destinationVC.infAdjTargetInvLow = self.eggroCalcs.infAdjTargetInvLow
            destinationVC.infAdjTargetInvHigh = self.eggroCalcs.infAdjTargetInvHigh
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
            return true
        } else {
            return false
        }
    }
}
    

