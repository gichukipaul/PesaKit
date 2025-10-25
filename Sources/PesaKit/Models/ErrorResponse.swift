//  ErrorResponse.swift
//  PesaKit
//  Created for handling M-Pesa API error responses

import Foundation

/// M-Pesa API error response model
public struct MpesaErrorResponse: Codable {
    public let requestId: String?
    public let errorCode: String?
    public let errorMessage: String?
    
    enum CodingKeys: String, CodingKey {
        case requestId
        case errorCode
        case errorMessage
    }
}

/// Authentication error response model
public struct AuthErrorResponse: Codable {
    public let error: String?
    public let error_description: String?
}
