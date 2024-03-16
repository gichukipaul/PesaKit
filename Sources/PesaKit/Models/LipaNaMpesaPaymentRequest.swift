    //  LipaNaMpesaPaymentRequest.swift
    //  Created by GichukiPaul on 16/03/2024.
import Foundation
public struct LipaNaMpesaPaymentRequest: Codable {
    let BusinessShortCode: Int
    let LipaNaMpesaPassKey: String
    let Timestamp: Int
    let TransactionType: TransactionType
    let Amount: Int
    let PartyA: Int
    let PartyB: Int
    let PhoneNumber: Int
    let CallBackURL: String
    let AccountReference: String
    let TransactionDesc: String
    private var Password: String {
            // This is the password used for encrypting the request sent: A base64 encoded string. (The base64 string is a combination of Shortcode+Passkey+Timestamp)
        let credentials = "\(BusinessShortCode)" + "\(LipaNaMpesaPassKey)" + "\(Timestamp)"
        return Data(credentials.utf8).base64EncodedString()
    }
    
    init(businessShortCode: Int, lipaNaMpesaPassKey: String, timestamp: Int, transactionType: TransactionType, amount: Int, partyA: Int, partyB: Int, phoneNumber: Int, callBackURL: String, accountReference: String, transactionDesc: String) {
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
