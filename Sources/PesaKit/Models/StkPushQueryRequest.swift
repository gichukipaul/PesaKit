//  StkPushQueryRequest.swift
//  PesaKit
//  STK Push Query Request Model

import Foundation

public struct StkPushQueryRequest: Codable {
    public let BusinessShortCode: Int
    public let Password: String
    public let Timestamp: String
    public let CheckoutRequestID: String

    public init(businessShortCode: Int, passKey: String, timestamp: String, checkoutRequestID: String) {
        self.BusinessShortCode = businessShortCode
        self.Timestamp = timestamp
        self.CheckoutRequestID = checkoutRequestID

        // Generate password: Base64(BusinessShortCode + PassKey + Timestamp)
        let credentials = "\(businessShortCode)\(passKey)\(timestamp)"
        self.Password = Data(credentials.utf8).base64EncodedString()
    }
}
