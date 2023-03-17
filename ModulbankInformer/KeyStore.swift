//
//  KeyStore.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 17.03.2023.
//

import Foundation
import KeychainAccess

class KeyStore {
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    func getAPIKey() -> String? {
        return keychain["APIKey"]
    }

    func saveAPIKey(_ key: String?) {
        keychain["APIKey"] = key
    }
}
