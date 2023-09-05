//
//  ViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource {

    var retrieveParseData = RetrieveParseData()
    var mostRecentYear: Int?
    var baseYear: Int?
    var selectedYear: String?
    var baseSpend: Int?
    var yearArray: [Int] = []
    var yearArrayAsStrings: [String] = ["Select Year"]
    var cpiDataArray: [[Any]] = [[]]

    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var baseSpendTextField: UITextField!
    
    @IBOutlet weak var calculateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        yearPicker.dataSource = self
        yearPicker.delegate = self
        yearPicker.isHidden = true
        
        baseSpendTextField.delegate = self
        baseSpendTextField.placeholder = "Pre-tax spending in base year"
        
        retrieveParseData.delegate = self
        
    }
    
    @objc func applicationWillEnterForeground(notification: Notification) {
        retrieveParseData.fetchData()
    }
    
    @IBAction func calculatePressed(_ sender: UIButton) {
        
        self.baseSpend = Int(baseSpendTextField.text?.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "$", with: "") ?? "0")
        
        self.baseSpendTextField.endEditing(true)
        self.baseSpendTextField.resignFirstResponder()
        
        
        if let baseYear = self.selectedYear {
            
            if self.selectedYear != "Select Year" && self.baseSpend != nil {
                
                self.mostRecentYear = self.cpiDataArray[0][0] as? Int
                
                self.baseYear = Int(baseYear)
                            
                self.performSegue(withIdentifier: "goToResults", sender: self)
                
                self.baseSpendTextField.text = nil
                
                self.selectedYear = "Select Year"
                
                self.yearPicker.selectRow(0, inComponent: 0, animated: true)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            let destinationVC = segue.destination as! ResultsViewController
            destinationVC.cpiDataArray = self.cpiDataArray
            destinationVC.mostRecentYear = self.mostRecentYear
            destinationVC.baseYear = self.baseYear
            destinationVC.baseSpend = self.baseSpend
        }
    }
}

extension ViewController: RetrieveParseDataDelegate, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.yearArrayAsStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(self.yearArrayAsStrings[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return selectedYear = self.yearArrayAsStrings[row]
    }

    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didRetrieveParseData(dataArray: [[Any]]) {
        
        self.cpiDataArray = dataArray
        self.yearArray = ((dataArray[0][0] as! Int - 10)...(dataArray[0][0] as! Int)).map { $0 }
        for year in self.yearArray {
            self.yearArrayAsStrings.append(String(year))
        }
        
        DispatchQueue.main.async {
            
            self.yearPicker.isHidden = false
            self.yearPicker.reloadAllComponents()
            
        }
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField)  {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.view.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let textFieldHasText = (textField.text), !textFieldHasText.isEmpty else {
            return true
        }

        let formatter = NumberFormatter()

        formatter.numberStyle = .currency
        formatter.locale = .current
        formatter.maximumFractionDigits = 0
        formatter.allowsFloats = false

        let textRemovedCommmaAndDollarSign = textFieldHasText.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "$", with: "")
        
        let formattedNum = formatter.string(from: NSNumber(value: Int(textRemovedCommmaAndDollarSign) ?? 0))
        textField.text = formattedNum
        return true
    }
    
}
    

