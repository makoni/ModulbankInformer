//
//  ContentView.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var apiStore: APIStore

    @State var isLoading = true

    var body: some View {
        VStack {
            if !isLoading {
                List {
                    ForEach(self.apiStore.accounts) { account in
                        Form {
                            Label {
                                Text(account.companyName ?? "")
                            } icon: {
                                Image(systemName: "signature")
                            }

                            ForEach(account.bankAccounts.filter({ $0.category != .transitAccount })) { bankAccount in
                                VStack {
                                    BankAccountView(bankAccount: bankAccount)
                                }
                            }
                        }
                    }
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            isLoading = true
            Task {
                do {
                    try await apiStore.getAccountInfo()
                } catch {
                    print(error)
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}


struct BankAccountView: View {
    @State var bankAccount: BankAccount

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: bankAccount.currency?.imageName ?? "banknote")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text("\(bankAccount.accountName ?? "Счёт")")
                    .font(.title2)

                Text("\(bankAccount.bankName ?? "")")
                    .font(.caption)
                Text(bankAccount.number ?? "")
                    .font(.caption)
            }

            Spacer()

            Text(self.formatBalance(bankAccount.balance))
                .font(.title)
                .padding(4)
                .background(Color("BlueColor"))
                .cornerRadius(14)
                .foregroundColor(.white)
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

let accData = """
{
     "accountName": "Карточный счёт",
     "balance": 4917.7600,
     "bankBic": "044525092",
     "bankInn": "2204000595",
     "bankKpp": "771543001",
     "bankCorrespondentAccount": "30101810645250000092",
     "bankName": "МОСКОВСКИЙ ФИЛИАЛ АО КБ МОДУЛЬБАНК",
     "beginDate": "2021-02-09T00:00:00",
     "category": "CheckingAccount",
     "currency": "RUR",
     "id": "\(NSUUID().uuidString)",
     "number": "12345678901234567890",
     "status": "New"
}
""".data(using: .utf8)!

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        VStack {
            BankAccountView(bankAccount: try! JSONDecoder().decode(BankAccount.self, from: accData))
            BankAccountView(bankAccount: try! JSONDecoder().decode(BankAccount.self, from: accData))
            BankAccountView(bankAccount: try! JSONDecoder().decode(BankAccount.self, from: accData))
        }
    }
}
