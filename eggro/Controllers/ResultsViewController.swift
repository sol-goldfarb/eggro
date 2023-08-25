//
//  ResultsViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/24/23.
//

import UIKit

class ResultsViewController: UIViewController {
    
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
        
        if let mostRecentMonth, let mostRecentYear {
            print("The most recently available data is from \(mostRecentMonth) \(mostRecentYear).")
        }
                
        if let mostRecentMonth, let baseYear, let infAdj {
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


extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

