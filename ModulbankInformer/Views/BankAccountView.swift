//
//  BankAccountView.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 27.11.2025.
//

import SwiftUI

struct BankAccountView: View {
	@State var bankAccount: BankAccount
	@State var transitBankAccount: BankAccount?

	var body: some View {
		VStack(alignment: .leading) {
			Text(formatBalance(bankAccount.balance))
				.font(.title)

			Text("\(bankAccount.accountName ?? "Счёт") \(bankAccount.number ?? "")")
				.font(.caption)

			if transitBankAccount != nil {
				let transitBalance = formatBalance(transitBankAccount!.balance)

				Label {
					Text("На транзитном счёте: \(transitBalance)")
						.font(.caption)
				} icon: {
					Image(systemName: "arrow.turn.down.right")
				}
			}
		}
	}

	func formatBalance(_ balance: Double) -> String {
		let formatter = NumberFormatter()
		formatter.numberStyle = .currency
		formatter.currencyCode = bankAccount.currency?.rawValue
		formatter.currencySymbol = bankAccount.currency?.currencySymbol
		formatter.maximumFractionDigits = 2

		let number = NSNumber(value: balance)

		return formatter.string(from: number) ?? "\(balance)"
	}
}
