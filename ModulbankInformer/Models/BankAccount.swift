//
//  BankAccount.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import Foundation

struct BankAccount: Codable, Identifiable {
    internal init(accountName: String? = nil, balance: Double, bankBic: String? = nil, bankInn: String? = nil, bankKpp: String? = nil, bankCorrespondentAccount: String? = nil, bankName: String? = nil, beginDate: Date? = nil, category: BankAccount.Category? = nil, currency: BankAccount.Currency? = nil, accountId: String, number: String? = nil, transitAccountId: String? = nil, status: BankAccount.Status? = nil) {
        self.accountName = accountName
        self.balance = balance
        self.bankBic = bankBic
        self.bankInn = bankInn
        self.bankKpp = bankKpp
        self.bankCorrespondentAccount = bankCorrespondentAccount
        self.bankName = bankName
        self.beginDate = beginDate
        self.category = category
        self.currency = currency
        self.accountId = accountId
        self.number = number
        self.transitAccountId = transitAccountId
        self.status = status
    }
    
	enum Category: String, Codable {
		case checkingAccount = "CheckingAccount"
		case depositAccount = "DepositAccount"
		case cardAccount = "CardAccount"
		case depositRateAccount = "DepositRateAccount"
		case reservationAccounting = "ReservationAccounting"
		case transitAccount = "TransitAccount"
	}

	enum Currency: String, Codable {
		case rur = "RUR"
		case usd = "USD"
		case eur = "EUR"
		case cny = "CNY"
		case kzt = "KZT"
		case amd = "AMD"
		case azn = "AZN"
		case gel = "GEL"
		case byn = "BYN"
		case tjs = "TJS"
		case uzs = "UZS"
		case `try` = "TRY"
		case kgs = "KGS"

		var imageName: String {
			switch self {
			case .rur:
				return "rublesign.square"
			case .usd:
				return "dollarsign.square"
			case .eur:
				return "eurosign.square"
			case .cny:
				return "yensign.square"
			case .kzt:
				return "tengesign.square"
			case .amd:
				return "banknote"
			case .azn:
				return "banknote"
			case .gel:
				return "banknote"
			case .byn:
				return "banknote"
			case .tjs:
				return "banknote"
			case .uzs:
				return "banknote"
			case .try:
				return "turkishlirasign.square"
			case .kgs:
				return "banknote"
			}
		}

		var currencySymbol: String {
			switch self {
			case .rur:
				return "₽"
			case .usd:
				return "$"
			case .eur:
				return "€"
			case .cny:
				return "¥"
			case .kzt:
				return "₸"
			case .amd:
				return "֏"
			case .azn:
				return "₼"
			case .gel:
				return "ლ"
			case .byn:
				return "Br"
			case .tjs:
				return self.rawValue
			case .uzs:
				return self.rawValue
			case .try:
				return "₺"
			case .kgs:
				return self.rawValue
			}
		}
	}

	enum Status: String, Codable {
		case new = "New"
		case deleted = "Deleted"
		case closed = "Closed"
		case freezed = "Freezed"
		case toClosed = "ToClosed"
		case toOpen = "ToOpen"

		var stringValue: String {
			switch self {
			case .new:
				return "открытый"
			case .deleted:
				return "удаленный"
			case .closed:
				return "закрытый"
			case .freezed:
				return "замороженный"
			case .toClosed:
				return "процессе закрытия"
			case .toOpen:
				return "в процессе открытия"
			}
		}
	}

	let id = UUID()
	let accountName: String?
	let balance: Double
	let bankBic: String?
	let bankInn: String?
	let bankKpp: String?
	let bankCorrespondentAccount: String?
	let bankName: String?
	let beginDate: Date?
	let category: Category?
	let currency: Currency?
	let accountId: String
	let number: String?
	let transitAccountId: String?
	let status: Status?

	enum CodingKeys: String, CodingKey {
		case accountName
		case balance
		case bankBic
		case bankInn
		case bankKpp
		case bankCorrespondentAccount
		case bankName
		case beginDate
		case category
		case currency
		case accountId = "id"
		case number
		case transitAccountId
		case status
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		accountName = try container.decodeIfPresent(String.self, forKey: .accountName)
		balance = try container.decodeIfPresent(Double.self, forKey: .balance) ?? 0
		bankBic = try container.decodeIfPresent(String.self, forKey: .bankBic)
		bankInn = try container.decodeIfPresent(String.self, forKey: .bankInn)
		bankKpp = try container.decodeIfPresent(String.self, forKey: .bankKpp)
		bankCorrespondentAccount = try container.decodeIfPresent(String.self, forKey: .bankCorrespondentAccount)
		bankName = try container.decodeIfPresent(String.self, forKey: .bankName)

		if let dateString =  try container.decodeIfPresent(String.self, forKey: .beginDate) {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			beginDate = dateFormatter.date(from: dateString)
		} else {
			beginDate = nil
		}

		category = try container.decodeIfPresent(BankAccount.Category.self, forKey: .category)
		currency = try container.decodeIfPresent(BankAccount.Currency.self, forKey: .currency)
		accountId = try container.decode(String.self, forKey: .accountId)
		number = try container.decodeIfPresent(String.self, forKey: .number)
		transitAccountId = try container.decodeIfPresent(String.self, forKey: .transitAccountId)
		status = try container.decodeIfPresent(BankAccount.Status.self, forKey: .status)
	}
}
