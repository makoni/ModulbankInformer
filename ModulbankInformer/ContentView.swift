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
                ForEach(self.apiStore.accounts) { account in
                    Form {
                        Label {
                            let string = (account.companyName ?? "").replacingOccurrences(of: "Индивидуальный предприниматель", with: "ИП")
                            Text("\(string)")
                        } icon: {
                            Image(systemName: "signature")
                        }
                        .padding(.bottom)

                        VStack(spacing: 8) {
                            ForEach(account.bankAccounts.filter({ $0.category != .transitAccount })) { bankAccount in

                                BankAccountView(bankAccount: bankAccount, transitBankAccount: account.bankAccounts.first(where: { $0.accountId == bankAccount.transitAccountId }))
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .padding()
        .frame(minWidth: 400, maxWidth: .infinity, minHeight: 200)
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
    @State var transitBankAccount: BankAccount?

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: bankAccount.currency?.imageName ?? "banknote")
                .font(.largeTitle)

            VStack(alignment: .leading) {
                Text(self.formatBalance(bankAccount.balance))
                    .font(.title)

//                let arr = [bankAccount.bankName, bankAccount.number].compactMap({ $0 })

//                Text("\(arr.joined(separator: ", "))")
//                    .font(.caption)

                Text("\(bankAccount.accountName ?? "Счёт") \(bankAccount.number ?? "")")
                    .font(.caption)
//                Text("\(bankAccount.number ?? "")")
//                    .font(.caption)

                if transitBankAccount != nil {
                    let transitBalance = self.formatBalance(transitBankAccount!.balance)

                    Label {
                        Text("На транзитном счёте: \(transitBalance)")
                            .font(.caption)
                    } icon: {
                        Image(systemName: "arrow.turn.down.right")
                    }
                }
            }

            Spacer()


//
//            Text(self.formatBalance(bankAccount.balance))
//                .font(.title3)
//                .padding(6)
//                .background(Color("BlueColor"))
//                .cornerRadius(20)
//                .foregroundColor(.white)
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
            let acc = try! JSONDecoder().decode(BankAccount.self, from: accData)
            BankAccountView(bankAccount: acc, transitBankAccount: acc)
            BankAccountView(bankAccount: try! JSONDecoder().decode(BankAccount.self, from: accData))
            BankAccountView(bankAccount: try! JSONDecoder().decode(BankAccount.self, from: accData))
        }
    }
}
