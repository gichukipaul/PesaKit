//  DynamicQRResponse.swift
//  PesaKit
//  Dynamic QR Response Model

import Foundation

public struct DynamicQRResponse: Codable {
    public let ResponseCode: String
    public let RequestID: String
    public let ResponseDescription: String
    public let QRCode: String
}
