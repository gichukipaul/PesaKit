//
//  PesaKitEnvironment.swift
//  Created by GichukiPaul on 16/03/2024.
//

import Foundation
public enum PesaKitEnvironment: String {
    case DEV
    case PRODUCTION
    
    public var credentialsUrl: String {
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

    var stkPushQueryUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/stkpushquery/v1/query"
        }
    }

    var dynamicQRUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/qrcode/v1/generate"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/qrcode/v1/generate"
        }
    }

    var c2bRegisterUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/c2b/v1/registerurl"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/c2b/v1/registerurl"
        }
    }

    var b2cUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/b2c/v3/paymentrequest"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/b2c/v3/paymentrequest"
        }
    }

    var transactionStatusUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/transactionstatus/v1/query"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/transactionstatus/v1/query"
        }
    }

    var accountBalanceUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/accountbalance/v1/query"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/accountbalance/v1/query"
        }
    }

    var reversalUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/reversal/v1/request"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/reversal/v1/request"
        }
    }

    var b2bUrl: String {
        switch self {
            case .DEV:
                return "https://sandbox.safaricom.co.ke/mpesa/b2b/v1/paymentrequest"
            case .PRODUCTION:
                return "https://api.safaricom.co.ke/mpesa/b2b/v1/paymentrequest"
        }
    }

}
