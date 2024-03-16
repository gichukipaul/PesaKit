    //  PSKitEnums.swift
    //  Created by GichukiPaul on 17/03/2024.

import Foundation
enum TransactionType: String, Codable {
    case PayBill
    case Till
    
    var transanctionType: String {
        switch self {
            case .PayBill:
                return "CustomerPayBillOnline"
            case .Till:
                return "CustomerBuyGoodsOnline"
        }
    }
}
    // MARK: PESAKIT ERRORS
enum PesaError: Error {
    case credentialsNotSet
    case invalidCredentials
    case invalidAccessToken
    case invalidEnvironment
    case unknownError
    case networkError(Error)
    case parsingError
    case encodingError(String)
}
