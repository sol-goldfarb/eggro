//
//  ViewController.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import UIKit

class ViewController: UIViewController {

    let networkManager = NetworkManager.shared
    var eggroBrain: EggroBrain = EggroBrain()

    override func viewDidLoad() {
        super.viewDidLoad()

        let baseYear = 2017
        let baseSpend = 200000

        networkManager.fetchData { [weak self] (data, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = data {
                if let dataArray = data as? [[Any]] {
                    self?.handleFetchedData(dataArray)
                    
                    print("Pre-tax spending in \(baseYear) was $\(baseSpend.withCommas()).")
                    
                    print("Base Year Target Investments (4% Withdrawal) = $\(self?.eggroBrain.baseTargetInvLow(baseSpend: baseSpend).withCommas() ?? "")")
                    
                    print("Base Year Target Investments (3% Withdrawal) = $\(self?.eggroBrain.baseTargetInvHigh(baseSpend: baseSpend).withCommas() ?? "")")
                    
                    print("The inflation adjustment from \(baseYear) to \(self?.eggroBrain.mostRecentYear() ?? 0) is \(String(format: "%.2f", self?.eggroBrain.infAdj(baseYear: baseYear) ?? 0.0))%.")
                    
                    print("The inflation adjusted spend is $\(self?.eggroBrain.infAdjSpend(baseYear: baseYear, baseSpend: baseSpend).withCommas() ?? "")")
                    
                    print("Inflation Adjusted Target Investments (4% Withdrawal) = $\(self?.eggroBrain.infAdjTargetInvLow(baseYear: baseYear, baseSpend: baseSpend).withCommas() ?? "")")
                    
                    print("Inflation Adjusted Target Investments (3% Withdrawal) = $\(self?.eggroBrain.infAdjTargetInvHigh(baseYear: baseYear, baseSpend: baseSpend).withCommas() ?? "")")
                } else {
                    print("Error: Failed to cast fetched data to the expected type.")
                }
            }
        }
    }

    func handleFetchedData(_ cpiData: [[Any]]) {
        eggroBrain.newCPIDataArray = cpiData
        let mostRecentCPIYear = cpiData[0][0]
        print("The most recent data for which CPI info is available is \(mostRecentCPIYear).")
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
