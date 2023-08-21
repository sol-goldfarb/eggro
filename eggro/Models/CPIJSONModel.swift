//
//  CPIJSONModel.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/21/23.
//

import Foundation

struct CPIJSONModel: Codable {
    let results: Results
    
    private enum CodingKeys: String, CodingKey {
        case results = "Results"
    }
}

struct Results: Codable {
    let series: [Series]
}

struct Series: Codable {
    let data: [data]
}

struct data: Codable {
    let year: String
    let period: String
    let periodName: String
    let value: String
}
