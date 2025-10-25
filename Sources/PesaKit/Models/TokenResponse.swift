//  TokenResponse.swift
//  Created by GichukiPaul on 17/03/2024.

import Foundation
public struct TokenResponse: Decodable {
    public let access_token: String
    public let expires_in: Int
}
