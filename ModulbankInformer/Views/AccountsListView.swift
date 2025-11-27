//
//  AccountsListView.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 27.11.2025.
//

import SwiftUI

struct AccountsListView: View {
	@AppStorage("hideZeros") private var hideZeros = false
	var accounts:  [AccountInfo]

	var body: some View {
		ForEach(accounts) { account in
			Form {
				Label {
					Text("\(account.shortenCompanyName)")
				} icon: { Image(systemName: "signature") }
					.padding(.bottom)


				VStack(alignment: .leading, spacing: 8) {
					ForEach(account.nonTransitAccounts(hideZeros: hideZeros)) { bankAccount in
						BankAccountView(
							bankAccount: bankAccount,
							transitBankAccount: account.bankAccounts.first(where: { $0.accountId == bankAccount.transitAccountId })
						)
					}
				}

				Toggle("Скрыть с нулевым балансом", isOn: $hideZeros)
					.padding([.top, .bottom])
			}
		}
	}
}
