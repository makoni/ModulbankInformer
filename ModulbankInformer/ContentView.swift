//
//  ContentView.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var apiStore: APIStore

    var body: some View {
        VStack {
            List {
                ForEach(self.apiStore.accounts) { account in
                    Form {
                        Label {
                            Text(account.companyName ?? "")
                        } icon: {
                            Image(systemName: "signature")
                        }

//                        ForEach(account.bankAccounts) { bankAccount in
//                            
//                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            Task {
                do {
                    try await apiStore.getAccountInfo()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(apiStore: APIStore())
    }
}
