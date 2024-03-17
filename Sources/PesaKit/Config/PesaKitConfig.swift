//
//  PesaKitConfig.swift
//  
//
//  Created by GichukiPaul on 16/03/2024.
//

import Foundation
public struct PesaKitConfig {
    let consumerKey: String
    let consumerSecret: String
    
    var credentials: String {
        "\(consumerKey):\(consumerSecret)"
    }
}
