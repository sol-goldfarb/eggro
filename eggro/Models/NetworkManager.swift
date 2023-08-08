//
//  NetworkManager.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import Foundation

struct NetworkManager {
    
    weak var delegate: NetworkManagerDelegate?
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchData(completion: @escaping (_ data: Any?, _ error: Error?) -> Void) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        guard let thisYear = Int(format.string(from: date)) else {
            return
        }
        let cpiDataUrl = "https://api.bls.gov/publicAPI/v2/timeseries/data/CUUR0000SA0/?registrationkey=\(PrivateK.BLSRegistrationKey)&startyear=\((thisYear) - 10)&endyear=\(thisYear)"
        
        guard let url = URL(string: cpiDataUrl) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            do {
                if let data = data {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(CPIData.self, from: data)
                    
                    let dataArray = response.results.series.first?.data ?? []
                    let CPIDataArray = dataArray.map { [Int($0.year) ?? 0, $0.period, $0.periodName, Double($0.value) ?? 0.0] as [Any] }
                    completion(CPIDataArray, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
    }
}
            

