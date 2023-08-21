//
//  EggroCalcBrain.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/21/23.
//

import Foundation

struct EggroCalcBrain {
    
    func infAdj(cpiDataArray: [[Any]], baseYear: Int) -> Double {
        let mostRecentYear = cpiDataArray[0][0] as! Int
        let mostRecentCPI = cpiDataArray[0][3] as! Double
        let baseCPI = cpiDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdj = ((mostRecentCPI / baseCPI) - 1.0) * 100
        return infAdj
    }
    
    func infAdjSpend(cpiDataArray: [[Any]], baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = cpiDataArray[0][0] as! Int
        let mostRecentCPI = cpiDataArray[0][3] as! Double
        let baseCPI = cpiDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let newInfAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        return newInfAdjSpend
    }
    
    func baseTargetInvLow(baseSpend: Int) -> Int {
        let baseTargetInvLow = 25 * baseSpend
        return baseTargetInvLow
    }
    
    func baseTargetInvHigh(baseSpend: Int) -> Int {
        let baseTargetInvHigh = 33 * baseSpend
        return baseTargetInvHigh
    }

    func infAdjTargetInvLow(cpiDataArray: [[Any]], baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = cpiDataArray[0][0] as! Int
        let mostRecentCPI = cpiDataArray[0][3] as! Double
        let baseCPI = cpiDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        let infAdjTargetInvLow = infAdjSpend * 25
        return infAdjTargetInvLow
    }
    
    func infAdjTargetInvHigh(cpiDataArray: [[Any]], baseYear: Int, baseSpend: Int) -> Int {
        let mostRecentYear = cpiDataArray[0][0] as! Int
        let mostRecentCPI = cpiDataArray[0][3] as! Double
        let baseCPI = cpiDataArray[12 * (mostRecentYear - baseYear)][3] as! Double
        let infAdjSpend = Int((mostRecentCPI/baseCPI * Double(baseSpend)))
        let infAdjTargetInvHigh = infAdjSpend * 33
        return infAdjTargetInvHigh
    }
    
}
