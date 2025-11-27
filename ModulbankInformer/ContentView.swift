//
//  ContentView.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import SwiftUI
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "ContentView")

struct ContentView: View {
	@Environment(\.openURL) private var openURL

	@ObservedObject var apiStore: APIStore

	@State private var isLoading = true
	@State private var apiKey: String = ""

	var body: some View {
		VStack(spacing: 16) {
			if !isLoading {
				AccountsListView(accounts: apiStore.accounts)
			} else if apiStore.hasAPIKey {
				ProgressView()
			}

			if !apiStore.hasAPIKey {
				VStack(spacing: 8) {
					Text("Введите ключ для доступа API")
					Text("Сгенерировать его в ЛК Модульбанка")
						.font(.caption)
					Text("Ключ будет храниться безопасно \nи его можно удалить в любой момент")
						.font(.caption)
					TextField("Введите ключ для доступа API", text: $apiKey, axis: .horizontal)
						.onSubmit {
							apiStore.setAPIKey(apiKey)
							Task { await loadData() }
						}
				}
			}

			HStack {
				if apiStore.hasAPIKey {
					Button {
						apiStore.setAPIKey(nil)
					} label: {
						Text("Отозвать доступ")
					}.padding(.trailing)
				} else {
					Button {
						openURL(URL(string: "https://my.modulbank.ru")!)
					} label: {
						Text("Открыть ЛК")
					}
				}

				Button { exit(0) } label: { Text("Выход") }
			}
		}
		.padding()
		.task { await loadData() }
	}

	func loadData() async {
		guard apiStore.hasAPIKey else { return }

		await MainActor.run {
			isLoading = true
		}

		do {
			try await apiStore.getAccountInfo()
		} catch {
			logger.error("\(String(describing: error), privacy: .public)")
		}

		await MainActor.run {
			isLoading = false
		}
	}
}

#Preview("Preview") {
    let accData = """
    {
        "companyId": "aa-aa-aa-aa",
        "companyName": "Индивидуальный предприниматель Иванов Иван Иванович",
        "bankAccounts": [
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
            },
            {
               "accountName": "Депозит",
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
        ],
        "registrationCompleted": true
    }
    """.data(using: .utf8)!
    let account = try! JSONDecoder().decode(AccountInfo.self, from: accData)

	AccountsListView(accounts: [account])
		.padding()
}
