//
//  EggroBrain.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/12/23.
//

import Foundation

struct EggroBrain {
    
    var newCPIDataArray: [[Any]] = []
    
    func mostRecentYear() -> Int {
        let mostRecentYear = newCPIDataArray[0][0] as! Int
        return mostRecentYear
    }
    
    func infAdj(baseYear: Int) -> Double {
        let mostRecentYear = newCPIDataArray[0][0] as! Int
        let mostRecentCPI = newCPIDataArray[0][3] as! Double
        let baseCPI = newCPIDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdj = ((mostRecentCPI / baseCPI) - 1.0) * 100
        return infAdj
    }
    
    func infAdjSpend(baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = newCPIDataArray[0][0] as! Int
        let mostRecentCPI = newCPIDataArray[0][3] as! Double
        let baseCPI = newCPIDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        return infAdjSpend
    }
    
    func baseTargetInvLow(baseSpend: Int) -> Int {
        let baseTargetInvLow = 25 * baseSpend
        return baseTargetInvLow
    }
    
    func baseTargetInvHigh(baseSpend: Int) -> Int {
        let baseTargetInvHigh = 33 * baseSpend
        return baseTargetInvHigh
    }

    func infAdjTargetInvLow(baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = newCPIDataArray[0][0] as! Int
        let mostRecentCPI = newCPIDataArray[0][3] as! Double
        let baseCPI = newCPIDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        let infAdjTargetInvLow = infAdjSpend * 25
        return infAdjTargetInvLow
    }
    
    func infAdjTargetInvHigh(baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = newCPIDataArray[0][0] as! Int
        let mostRecentCPI = newCPIDataArray[0][3] as! Double
        let baseCPI = newCPIDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        let infAdjTargetInvHigh = infAdjSpend * 33
        return infAdjTargetInvHigh
    }
    
}
