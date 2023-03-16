//
//  AccountInfo.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import Foundation

struct AccountInfo: Codable {
    let companyId: String
    let companyName: String?
    let bankAccounts: [BankAccount]
    let registrationCompleted: Bool
    let Inn: String?
    let Kpp: String?
    let Ogrn: String?

    enum CodingKeys: CodingKey {
        case companyId
        case companyName
        case bankAccounts
        case registrationCompleted
        case Inn
        case Kpp
        case Ogrn
    }

    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<AccountInfo.CodingKeys> = try decoder.container(keyedBy: AccountInfo.CodingKeys.self)

        self.companyId = try container.decodeIfPresent(String.self, forKey: AccountInfo.CodingKeys.companyId) ?? ""
        self.companyName = try container.decodeIfPresent(String.self, forKey: AccountInfo.CodingKeys.companyName)
        self.bankAccounts = try container.decodeIfPresent([BankAccount].self, forKey: AccountInfo.CodingKeys.bankAccounts) ?? []
        self.registrationCompleted = try container.decodeIfPresent(Bool.self, forKey: AccountInfo.CodingKeys.registrationCompleted) ?? false
        self.Inn = try container.decodeIfPresent(String.self, forKey: AccountInfo.CodingKeys.Inn)
        self.Kpp = try container.decodeIfPresent(String.self, forKey: AccountInfo.CodingKeys.Kpp)
        self.Ogrn = try container.decodeIfPresent(String.self, forKey: AccountInfo.CodingKeys.Ogrn)

    }

    func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<AccountInfo.CodingKeys> = encoder.container(keyedBy: AccountInfo.CodingKeys.self)

        try container.encode(self.companyId, forKey: AccountInfo.CodingKeys.companyId)
        try container.encodeIfPresent(self.companyName, forKey: AccountInfo.CodingKeys.companyName)
        try container.encode(self.bankAccounts, forKey: AccountInfo.CodingKeys.bankAccounts)
        try container.encode(self.registrationCompleted, forKey: AccountInfo.CodingKeys.registrationCompleted)
        try container.encodeIfPresent(self.Inn, forKey: AccountInfo.CodingKeys.Inn)
        try container.encodeIfPresent(self.Kpp, forKey: AccountInfo.CodingKeys.Kpp)
        try container.encodeIfPresent(self.Ogrn, forKey: AccountInfo.CodingKeys.Ogrn)
    }
}
