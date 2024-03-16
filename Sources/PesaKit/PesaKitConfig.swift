//
//  PesaKitConfig.swift
//  
//
//  Created by user on 16/03/2024.
//

import Foundation
struct PesaKitConfig {
    let consumerKey: String
    let consumerSecret: String
    
    var credentials: String {
        "\(consumerKey):\(consumerSecret)"
    }
}
