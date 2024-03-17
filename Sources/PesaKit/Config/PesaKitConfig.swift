//
//  PesaKitConfig.swift
//  
//
//  Created by GichukiPaul on 16/03/2024.
//

import Foundation
public struct PesaKitConfig {
    public let consumerKey: String
    public let consumerSecret: String
    
    public init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
    var credentials: String {
        "\(consumerKey):\(consumerSecret)"
    }
}
