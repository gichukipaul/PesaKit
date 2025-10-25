//  B2BRequest.swift
//  PesaKit
//  Business to Business Payment Request Model

import Foundation

public struct B2BRequest: Codable {
    public let Initiator: String
    public let SecurityCredential: String
    public let CommandID: B2BCommandID
    public let SenderIdentifierType: String
    public let RecieverIdentifierType: String
    public let Amount: Int
    public let PartyA: String
    public let PartyB: String
    public let AccountReference: String
    public let Requester: String
    public let Remarks: String
    public let QueueTimeOutURL: String
    public let ResultURL: String

    public init(initiator: String, securityCredential: String, commandID: B2BCommandID, amount: Int, partyA: String, partyB: String, accountReference: String, requester: String = "", remarks: String, queueTimeOutURL: String, resultURL: String, senderIdentifierType: String = "4", receiverIdentifierType: String = "4") {
        self.Initiator = initiator
        self.SecurityCredential = securityCredential
        self.CommandID = commandID
        self.SenderIdentifierType = senderIdentifierType
        self.RecieverIdentifierType = receiverIdentifierType
        self.Amount = amount
        self.PartyA = partyA
        self.PartyB = partyB
        self.AccountReference = accountReference
        self.Requester = requester
        self.Remarks = remarks
        self.QueueTimeOutURL = queueTimeOutURL
        self.ResultURL = resultURL
    }
}

public enum B2BCommandID: String, Codable {
    case BusinessPayBill
    case BusinessBuyGoods
}
