//  KeychainManager.swift
//  PesaKit
//  Created for secure token storage

import Foundation
import Security

internal class KeychainManager {
    
    static let shared = KeychainManager()
    
    private let service = "com.pesakit.tokens"
    private let accessTokenKey = "access_token"
    private let tokenExpiryKey = "token_expiry"
    
    private init() {}
    
    // MARK: - Token Storage
    
    func saveToken(_ token: String, expiresIn: Int) {
        let expiryDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        
        // Save access token
        save(token, forKey: accessTokenKey)
        
        // Save expiry timestamp
        let expiryTimestamp = String(expiryDate.timeIntervalSince1970)
        save(expiryTimestamp, forKey: tokenExpiryKey)
    }
    
    func getToken() -> String? {
        // Check if token is expired
        if isTokenExpired() {
            deleteToken()
            return nil
        }
        
        return retrieve(forKey: accessTokenKey)
    }
    
    func deleteToken() {
        delete(forKey: accessTokenKey)
        delete(forKey: tokenExpiryKey)
    }
    
    private func isTokenExpired() -> Bool {
        guard let expiryString = retrieve(forKey: tokenExpiryKey),
              let expiryTimestamp = TimeInterval(expiryString) else {
            return true
        }
        
        let expiryDate = Date(timeIntervalSince1970: expiryTimestamp)
        return Date() >= expiryDate
    }
    
    // MARK: - Generic Keychain Operations
    
    private func save(_ value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        // First, delete any existing item
        delete(forKey: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func retrieve(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return value
    }
    
    private func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
