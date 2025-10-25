    //  PSKitEnums.swift
    //  Created by GichukiPaul on 17/03/2024.

import Foundation
public enum TransactionType: String, Codable {
    case PayBill = "CustomerPayBillOnline"
    case Till = "CustomerBuyGoodsOnline"
}
    // MARK: PESAKIT ERRORS
public enum PesaError: Error {
    case credentialsNotSet
    case invalidCredentials
    case invalidAccessToken
    case invalidEnvironment
    case unknownError
    case networkError(Error)
    case parsingError
    case encodingError(String)
    case mpesaError(MpesaErrorResponse)
    case authenticationError(AuthErrorResponse)

    public var localizedDescription: String {
        switch self {
        case .credentialsNotSet:
            return "Credentials have not been set. Please configure PesaKit with valid credentials."
        case .invalidCredentials:
            return "The provided credentials are invalid."
        case .invalidAccessToken:
            return "Access token is invalid or expired."
        case .invalidEnvironment:
            return "Invalid environment configuration."
        case .unknownError:
            return "An unknown error occurred."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .parsingError:
            return "Failed to parse response data."
        case .encodingError(let message):
            return "Encoding error: \(message)"
        case .mpesaError(let response):
            return "M-Pesa error: \(response.errorMessage ?? "Unknown error") (Code: \(response.errorCode ?? "N/A"))"
        case .authenticationError(let response):
            return "Authentication error: \(response.error_description ?? response.error ?? "Unknown error")"
        }
    }
}
