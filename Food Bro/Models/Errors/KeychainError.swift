//
//  KeychainError.swift
//  Food Bro
//
//  Created by Tomasz Parys on 01/07/2024.
//

import Foundation

enum KeychainError: Error {
    case encodeError
    case duplicateEntry
    case itemNotFound
    case unhandledError(_ status: OSStatus)
}
