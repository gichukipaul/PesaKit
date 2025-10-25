//  C2BRegisterURLResponse.swift
//  PesaKit
//  C2B Register URL Response Model

import Foundation

public struct C2BRegisterURLResponse: Codable {
    public let OriginatorCoversationID: String
    public let ResponseCode: String
    public let ResponseDescription: String
}
