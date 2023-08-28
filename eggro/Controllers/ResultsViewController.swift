//
//  ResultsViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/24/23.
//

import UIKit

class ResultsViewController: UIViewController {
    
    var eggroCalcBrain = EggroCalcBrain()
    var eggroCalcs: (infAdj: Double?, infAdjSpend: Int?, baseTargetInvLow: Int?, baseTargetInvHigh: Int?, infAdjTargetInvLow: Int?, infAdjTargetInvHigh: Int?)
    
    var cpiDataArray: [[Any]]?
    var mostRecentMonth: String?
    var mostRecentYear: Int?
    var baseYear: Int?
    var baseSpend: Int?
    var infAdj: Double?
    var infAdjSpend: Int?
    var baseTargetInvLow: Int?
    var baseTargetInvHigh: Int?
    var infAdjTargetInvLow: Int?
    var infAdjTargetInvHigh: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let baseYear, let baseSpend, let cpiDataArray {
            self.eggroCalcs = self.eggroCalcBrain.performCalcs(cpiDataArray: cpiDataArray, baseYear: baseYear, baseSpend: baseSpend)
            self.mostRecentMonth = cpiDataArray[0][2] as? String
            self.infAdj = self.eggroCalcs.infAdj
            self.infAdjSpend = self.eggroCalcs.infAdjSpend
            self.baseTargetInvLow = self.eggroCalcs.baseTargetInvLow
            self.baseTargetInvHigh = self.eggroCalcs.baseTargetInvHigh
            self.infAdjTargetInvLow = self.eggroCalcs.infAdjTargetInvLow
            self.infAdjTargetInvHigh = self.eggroCalcs.infAdjTargetInvHigh
            
            if let mostRecentMonth, let mostRecentYear {
                print("The most recently available data is from \(mostRecentMonth) \(mostRecentYear).")
            }
                    
            if let mostRecentMonth, let infAdj {
                print("Inflation since \(mostRecentMonth) \(baseYear) is \(String(format: "%.2f", (infAdj)))%.")
            }
            
            if let infAdjSpend {
                print("The inflation adjusted spend is $\(infAdjSpend.withCommas()).")
            }
            
            if let baseTargetInvLow {
                print("Base Year Target Investments (4% Withdrawal) = $\(baseTargetInvLow.withCommas()).")
            }
            
            if let baseTargetInvHigh {
                print("Base Year Target Investments (3% Withdrawal) = $\(baseTargetInvHigh.withCommas()).")
            }
            
            if let infAdjTargetInvLow {
                print("Inflation Adjusted Target Investments (4% Withdrawal) = $\(infAdjTargetInvLow.withCommas()).")
            }
            
            if let infAdjTargetInvHigh {
                print("Inflation Adjusted Target Investments (3% Withdrawal) = $\(infAdjTargetInvHigh.withCommas()).")
            }
        }
    }
    
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}


