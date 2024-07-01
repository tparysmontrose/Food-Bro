//
//  SecureStore.swift
//  Food Bro
//
//  Created by Tomasz Parys on 01/07/2024.
//

import Foundation
import Security

class SecureStore {
    
    static let shared = SecureStore()
    
    private init(){}
    
    func save(value: String, for key: String) throws {
        guard let encodedValue = value.data(using: .utf8), let key = key.data(using: .utf8) else {
            throw KeychainError.encodeError
        }
        
        let query: [String : Any] = [kSecClass as String : kSecClassKey,
                                     kSecAttrApplicationTag as String : key,
                                     kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
                                     kSecValueData as String : encodedValue
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status) }
    }
    
    func getValue(for key: String) throws -> String {
        let query: [String: AnyObject] = [
            kSecClass as String : kSecClassKey,
            kSecAttrApplicationTag as String : key as AnyObject,
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
            kSecReturnData as String : kCFBooleanTrue,
            kSecMatchLimit as String : kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {throw KeychainError.itemNotFound}
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status)}
        
        let data = item as? Data ?? Data()
        let str = String(decoding: data, as: UTF8.self)
        return str
    }
    
    func deleteValue(for key: String) throws {
        let query: [String: AnyObject] = [
            kSecClass as String : kSecClassKey,
            kSecAttrApplicationTag as String : key as AnyObject,
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status)}
    }
    
    func updateValue(value: String, for key: String) throws {
        guard let encodedValue = value.data(using: .utf8), let key = key.data(using: .utf8) else {
            throw KeychainError.encodeError
        }
        
        let query: [String: AnyObject] = [
            kSecClass as String : kSecClassKey,
            kSecAttrApplicationTag as String : key as AnyObject,
            kSecAttrKeyType as String : kSecAttrKeyTypeRSA,
        ]
        
        let attributes: [String: Any] = [kSecValueData as String : encodedValue]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.itemNotFound }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status)}
    }
}
