    //  TokenResponse.swift
    //  Created by GichukiPaul on 17/03/2024.

import Foundation
public struct TokenResponse: Decodable {
    let access_token: String
    let expires_in: Int
}
