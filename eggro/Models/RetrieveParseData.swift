//
//  RetrieveParseData.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/21/23.
//

import Foundation

protocol RetrieveParseDataDelegate {
    func didRetrieveParseData(dataArray: [[Any]])
    func didFailWithError(error: Error)
}

struct RetrieveParseData {
    
    var delegate: RetrieveParseDataDelegate?
    
    func fetchData() {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let thisYear = Int(format.string(from: date))
        let cpiDataUrl = "https://api.bls.gov/publicAPI/v2/timeseries/data/CUUR0000SA0/?registrationkey=\(PrivateK.BLSRegistrationKey)&startyear=\((thisYear ?? 1900) - 10)&endyear=\(thisYear ?? 1900)"
        
        if let url = URL(string: cpiDataUrl) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safedata = data {
                    if let CPIDataArray = self.parseJSON(safedata) {
                        self.delegate?.didRetrieveParseData(dataArray: CPIDataArray)
                    }
                }
            }
            task.resume()
        }
    }
        
    func parseJSON(_ data: Data) -> [[Any]]? {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(CPIJSONModel.self, from: data)
            let dataArray = response.results.series.first?.data ?? []
            let CPIDataArray = dataArray.map { [Int($0.year) ?? 0, $0.period, $0.periodName, Double($0.value) ?? 0.0] as [Any] }
            return CPIDataArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


