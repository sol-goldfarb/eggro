//
//  NetworkManagerDelegate.swift
//  eggro
//
//  Created by Solomon Goldfarb on 8/13/23.
//

import Foundation

protocol NetworkManagerDelegate: AnyObject {
    func didUpdateCPIData(cpiDataArray: [[Any]])
    func didFailWithError(error: Error)
}
 
 
