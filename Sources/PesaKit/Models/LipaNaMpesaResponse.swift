    //  LipaNaMpesaResponse.swift
    //  Created by GichukiPaul on 16/03/2024.
import Foundation
public struct LipaNaMpesaResponse: Codable {
    let MerchantRequestID: String
    let CheckoutRequestID: String
    let ResponseCode: String
    let ResponseDescription: String
    let CustomerMessage: String
}
