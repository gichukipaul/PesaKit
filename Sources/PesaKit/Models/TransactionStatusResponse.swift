//  TransactionStatusResponse.swift
//  PesaKit
//  Transaction Status Query Response Model

import Foundation

public struct TransactionStatusResponse: Codable {
    public let OriginatorConversationID: String
    public let ConversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
