//  StkPushQueryResponse.swift
//  PesaKit
//  STK Push Query Response Model

import Foundation

public struct StkPushQueryResponse: Codable {
    public let ResponseCode: String
    public let ResponseDescription: String
    public let MerchantRequestID: String
    public let CheckoutRequestID: String
    public let ResultCode: String
    public let ResultDesc: String
}
