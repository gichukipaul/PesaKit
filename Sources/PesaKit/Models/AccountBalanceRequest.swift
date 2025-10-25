//  AccountBalanceRequest.swift
//  PesaKit
//  Account Balance Query Request Model

import Foundation

public struct AccountBalanceRequest: Codable {
    public let Initiator: String
    public let SecurityCredential: String
    public let CommandID: String
    public let PartyA: String
    public let IdentifierType: String
    public let Remarks: String
    public let QueueTimeOutURL: String
    public let ResultURL: String
    
    public init(initiator: String, securityCredential: String, partyA: String, identifierType: String = "4", remarks: String, queueTimeOutURL: String, resultURL: String) {
        self.Initiator = initiator
        self.SecurityCredential = securityCredential
        self.CommandID = "AccountBalance"
        self.PartyA = partyA
        self.IdentifierType = identifierType
        self.Remarks = remarks
        self.QueueTimeOutURL = queueTimeOutURL
        self.ResultURL = resultURL
    }
}
