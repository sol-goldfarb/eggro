//
//  ViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import UIKit

class ViewController: UIViewController {

    var retrieveParseData = RetrieveParseData()
    var eggroCalcBrain = EggroCalcBrain()

    @IBOutlet weak var infAdjSpendLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveParseData.delegate = self
        retrieveParseData.fetchData()
    }
    
}

extension ViewController: RetrieveParseDataDelegate {
    
    func didRetrieveParseData(dataArray: [[Any]]) {
        DispatchQueue.main.async {
            
            let baseYear = 2017
            let yearsSinceBase = dataArray[0][0] as! Int - baseYear
            let baseSpend = 200000
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
