//  LipaNaMpesaPaymentRequest.swift
//  Created by GichukiPaul on 16/03/2024.
import Foundation
public struct LipaNaMpesaPaymentRequest: Codable {
    public let BusinessShortCode: Int
    public let LipaNaMpesaPassKey: String
    public let Timestamp: Int
    public let TransactionType: TransactionType
    public let Amount: Int
    public let PartyA: Int
    public let PartyB: Int
    public let PhoneNumber: Int
    public let CallBackURL: String
    public let AccountReference: String
    public let TransactionDesc: String
    private var Password: String {
        // This is the password used for encrypting the request sent: A base64 encoded string. (The base64 string is a combination of Shortcode+Passkey+Timestamp)
        let credentials = "\(BusinessShortCode)" + "\(LipaNaMpesaPassKey)" + "\(Timestamp)"
        return Data(credentials.utf8).base64EncodedString()
    }
    
    public init(businessShortCode: Int, lipaNaMpesaPassKey: String, timestamp: Int, transactionType: TransactionType, amount: Int, partyA: Int, partyB: Int, phoneNumber: Int, callBackURL: String, accountReference: String, transactionDesc: String) {
        self.BusinessShortCode = businessShortCode
        self.LipaNaMpesaPassKey = lipaNaMpesaPassKey
        self.Timestamp = timestamp
        self.TransactionType = transactionType
        self.Amount = amount
        self.PartyA = partyA
        self.PartyB = partyB
        self.PhoneNumber = phoneNumber
        self.CallBackURL = callBackURL
        self.AccountReference = accountReference
        self.TransactionDesc = transactionDesc
    }
    
}
