//  LipaNaMpesaResponse.swift
//  Created by GichukiPaul on 16/03/2024.
import Foundation
public struct LipaNaMpesaResponse: Codable {
    public let MerchantRequestID: String
    public let CheckoutRequestID: String
    public let ResponseCode: String
    public let ResponseDescription: String
    public let CustomerMessage: String
}
