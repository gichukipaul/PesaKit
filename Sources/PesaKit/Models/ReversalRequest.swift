//  ReversalRequest.swift
//  PesaKit
//  Transaction Reversal Request Model

import Foundation

public struct ReversalRequest: Codable {
    public let Initiator: String
    public let SecurityCredential: String
    public let CommandID: String
    public let TransactionID: String
    public let Amount: Int
    public let ReceiverParty: String
    public let RecieverIdentifierType: String
    public let ResultURL: String
    public let QueueTimeOutURL: String
    public let Remarks: String
    public let Occasion: String

    public init(initiator: String, securityCredential: String, transactionID: String, amount: Int, receiverParty: String, receiverIdentifierType: String = "11", resultURL: String, queueTimeOutURL: String, remarks: String, occasion: String = "") {
        self.Initiator = initiator
        self.SecurityCredential = securityCredential
        self.CommandID = "TransactionReversal"
        self.TransactionID = transactionID
        self.Amount = amount
        self.ReceiverParty = receiverParty
        self.RecieverIdentifierType = receiverIdentifierType
        self.ResultURL = resultURL
        self.QueueTimeOutURL = queueTimeOutURL
        self.Remarks = remarks
        self.Occasion = occasion
    }
}
