//
//  KeychainService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/15.
//

import Foundation
import Security

final class KeychainService {
    
    static let shared = KeychainService()
    
    var token: String?
    
    private init() {
        print("Try write Keychain: \(createToken("Hello"))")
        token = readToken()
    }
    
    func createToken(_ token: String) -> Bool {
        guard let data = token.data(using: .utf8, allowLossyConversion: false) else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrServer: "Danji",
            kSecAttrAccount: "user",
            kSecValueData: data
        ]
        SecItemDelete(query as CFDictionary)
        
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    func readToken() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrServer: "Danji",
            kSecAttrAccount: "user",
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: kCFBooleanTrue!,
            kSecReturnData: kCFBooleanTrue!
        ]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [CFString: Any],
              let data = existingItem[kSecAttrGeneric] as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    func updateToken(_ token: String) -> Bool {
        guard let data = try? JSONEncoder().encode(token) else { return false }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrServer: "Danji",
            kSecAttrAccount: "user"
        ]
        
        let attributes: [CFString: Any] = [
            kSecAttrAccount: "Danji",
            kSecAttrGeneric: data
        ]
        
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }
    
    func deleteToken() -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrServer: "Danji",
            kSecAttrAccount: "user"
        ]
        
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
}
