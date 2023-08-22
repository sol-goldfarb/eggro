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
    var baseSpend: Int?
    let yearArray: [String] = ["2013","2014","2015","2016","2017","2018","2019","2020","2021","2022","2023"]

    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var infAdjSpendLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        yearPicker.dataSource = self
        yearPicker.delegate = self
        retrieveParseData.delegate = self
        retrieveParseData.fetchData()
        
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return yearArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedYear = yearArray[row]
//        coinManager.getCoinPrice(cryptoType: "BTC", currency: selectedCurrency)
    }

}

extension ViewController: RetrieveParseDataDelegate {
    
    func didRetrieveParseData(dataArray: [[Any]]) {
        
        baseYear = 2017
        baseSpend = 200000
        
        DispatchQueue.main.async {
            
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
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
