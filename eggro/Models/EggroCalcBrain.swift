//
//  EggroCalcBrain.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/21/23.
//

import Foundation

struct EggroCalcBrain {
    
    func performCalcs(cpiDataArray: [[Any]], baseYear: Int, baseSpend: Int) -> (infAdj: Double, infAdjSpend: Int, baseTargetInvLow: Int, baseTargetInvHigh: Int, infAdjTargetInvLow: Int, infAdjTargetInvHigh: Int) {
 
        let mostRecentYear = cpiDataArray[0][0] as! Int
        let mostRecentCPI = cpiDataArray[0][3] as! Double
        let baseCPI = cpiDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        
        let infAdj = ((mostRecentCPI / baseCPI) - 1.0) * 100
        
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        
        let baseTargetInvLow = 25 * baseSpend

        let baseTargetInvHigh = 33 * baseSpend

        let infAdjTargetInvLow = infAdjSpend * 25

        let infAdjTargetInvHigh = infAdjSpend * 33

        return (infAdj, infAdjSpend, baseTargetInvLow, baseTargetInvHigh, infAdjTargetInvLow, infAdjTargetInvHigh)
    }
    
}
