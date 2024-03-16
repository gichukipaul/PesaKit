//
//  PesaKitEnvironment.swift
//  Created by GichukiPaul on 16/03/2024.
//

import Foundation
enum PesaKitEnvironment: String {
    case DEV
    case PRODUCTION
    
    var credentialsUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials"
        }
    }
    
    var lipaNaMpesaUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
        }
    }
    
}
