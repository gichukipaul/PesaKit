//  AccountBalanceResponse.swift
//  PesaKit
//  Account Balance Query Response Model

import Foundation

public struct AccountBalanceResponse: Codable {
    public let OriginatorConversationID: String
    public let ConversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
