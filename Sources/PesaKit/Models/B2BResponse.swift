//  B2BResponse.swift
//  PesaKit
//  Business to Business Payment Response Model

import Foundation

public struct B2BResponse: Codable {
    public let OriginatorConversationID: String
    public let ConversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
