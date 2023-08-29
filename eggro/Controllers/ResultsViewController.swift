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

    @IBOutlet weak var baseSpendAmtLabel: UILabel!
    @IBOutlet weak var baseSpendExplanationLabel: UILabel!
    
    @IBOutlet weak var infAdjSpendAmtLabel: UILabel!
    @IBOutlet weak var infAdjSpendExplanationLabel: UILabel!
    
    @IBOutlet weak var targetInvLowAmtLabel: UILabel!
    @IBOutlet weak var targetInvLowExplanationLabel: UILabel!
    
    @IBOutlet weak var targetInvHighAmtLabel: UILabel!
    @IBOutlet weak var targetInvHighExplanationLabel: UILabel!
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
                
                baseSpendAmtLabel.text = "$\(baseSpend.withCommas())"
                
                baseSpendExplanationLabel.text = "Pre-tax spending in \(baseYear)"
            }
            
            if let infAdjSpend {
                infAdjSpendAmtLabel.text = "$\(infAdjSpend.withCommas())"
            }
            
            if let mostRecentMonth, let mostRecentYear, let infAdj {
                infAdjSpendExplanationLabel.text = "Base spend adjusted for \(String(format: "%.2f", (infAdj)))% inflation from \(mostRecentMonth) \(baseYear) to \(mostRecentMonth) \(mostRecentYear)"
            }
            
            if let infAdjTargetInvLow {
                targetInvLowAmtLabel.text = "$\(infAdjTargetInvLow.withCommas())"
            }
            
            if let mostRecentMonth, let mostRecentYear {
                targetInvLowExplanationLabel.text = "Target investment level assuming 4% annual withdrawal rate, using \(mostRecentMonth) \(mostRecentYear) inflation-adjusted spending"
            }
            
            if let infAdjTargetInvHigh {
                targetInvHighAmtLabel.text = "$\(infAdjTargetInvHigh.withCommas())"
            }
            
            if let mostRecentMonth, let mostRecentYear {
                targetInvHighExplanationLabel.text = "Target investment level assuming 3% annual withdrawal rate, using \(mostRecentMonth) \(mostRecentYear) inflation-adjusted spending"
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


