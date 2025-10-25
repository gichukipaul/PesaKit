//  C2BRegisterURLRequest.swift
//  PesaKit
//  C2B Register URL Request Model

import Foundation

public struct C2BRegisterURLRequest: Codable {
    public let ShortCode: String
    public let ResponseType: ResponseType
    public let ConfirmationURL: String
    public let ValidationURL: String
    
    public init(shortCode: String, responseType: ResponseType, confirmationURL: String, validationURL: String) {
        self.ShortCode = shortCode
        self.ResponseType = responseType
        self.ConfirmationURL = confirmationURL
        self.ValidationURL = validationURL
    }
}

public enum ResponseType: String, Codable {
    case Cancelled
    case Completed
}
