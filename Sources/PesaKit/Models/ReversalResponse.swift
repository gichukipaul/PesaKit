//  ReversalResponse.swift
//  PesaKit
//  Transaction Reversal Response Model

import Foundation

public struct ReversalResponse: Codable {
    public let OriginatorConversationID: String
    public let ConversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
