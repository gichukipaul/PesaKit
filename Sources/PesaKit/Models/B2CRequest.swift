//  B2CRequest.swift
//  PesaKit
//  Business to Customer Payment Request Model

import Foundation

public struct B2CRequest: Codable {
    public let OriginatorConversationID: String
    public let InitiatorName: String
    public let SecurityCredential: String
    public let CommandID: B2CCommandID
    public let Amount: Int
    public let PartyA: String
    public let PartyB: String
    public let Remarks: String
    public let QueueTimeOutURL: String
    public let ResultURL: String
    public let Occassion: String

    public init(originatorConversationID: String, initiatorName: String, securityCredential: String, commandID: B2CCommandID, amount: Int, partyA: String, partyB: String, remarks: String, queueTimeOutURL: String, resultURL: String, occassion: String = "") {
        self.OriginatorConversationID = originatorConversationID
        self.InitiatorName = initiatorName
        self.SecurityCredential = securityCredential
        self.CommandID = commandID
        self.Amount = amount
        self.PartyA = partyA
        self.PartyB = partyB
        self.Remarks = remarks
        self.QueueTimeOutURL = queueTimeOutURL
        self.ResultURL = resultURL
        self.Occassion = occassion
    }
}

public enum B2CCommandID: String, Codable {
    case SalaryPayment
    case BusinessPayment
    case PromotionPayment
}
