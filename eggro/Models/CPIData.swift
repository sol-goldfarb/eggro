//
//  CPIData.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/8/23.
//

import Foundation

struct CPIData: Codable {
    let results: Results
    
    private enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}

struct Results: Codable {
    let series: [Series]
}

struct Series: Codable {
    let data: [Data]
}

struct Data: Codable {
    let year: String
    let period: String
    let periodName: String
    let value: String
}

