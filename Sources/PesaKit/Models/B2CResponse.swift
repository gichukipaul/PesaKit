//  B2CResponse.swift
//  PesaKit
//  Business to Customer Payment Response Model

import Foundation

public struct B2CResponse: Codable {
    public let ConversationID: String
    public let OriginatorConversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
