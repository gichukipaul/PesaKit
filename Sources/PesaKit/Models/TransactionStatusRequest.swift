//  TransactionStatusRequest.swift
//  PesaKit
//  Transaction Status Query Request Model

import Foundation

public struct TransactionStatusRequest: Codable {
    public let Initiator: String
    public let SecurityCredential: String
    public let CommandID: String
    public let TransactionID: String
    public let OriginatorConversationID: String
    public let PartyA: String
    public let IdentifierType: String
    public let ResultURL: String
    public let QueueTimeOutURL: String
    public let Remarks: String
    public let Occasion: String

    public init(initiator: String, securityCredential: String, transactionID: String, originatorConversationID: String, partyA: String, identifierType: String = "4", resultURL: String, queueTimeOutURL: String, remarks: String, occasion: String = "") {
        self.Initiator = initiator
        self.SecurityCredential = securityCredential
        self.CommandID = "TransactionStatusQuery"
        self.TransactionID = transactionID
        self.OriginatorConversationID = originatorConversationID
        self.PartyA = partyA
        self.IdentifierType = identifierType
        self.ResultURL = resultURL
        self.QueueTimeOutURL = queueTimeOutURL
        self.Remarks = remarks
        self.Occasion = occasion
    }
}
