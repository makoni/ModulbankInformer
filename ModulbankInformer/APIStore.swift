//
//  APIStore.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import Foundation
import OSLog

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "APIStore")

// API docs: https://api.modulbank.ru

class APIStore: ObservableObject {
    private let keyStore = KeyStore()

    @Published var hasAPIKey: Bool
    @Published var accounts: [AccountInfo] = []

    enum APIError: Error {
        case badURL
    }

    enum HTTPMethod: String {
        case GET, POST, PUT, DELETE
    }

    var timer: Timer?

    init(accounts: [AccountInfo] = []) {
        self.accounts = accounts
        self.hasAPIKey = keyStore.getAPIKey() != nil
        self.timer = Timer.scheduledTimer(withTimeInterval: 60*5, repeats: true, block: { timer in
            Task {
				do {
					try await self.getAccountInfo()
				} catch {
					logger.error("\(String(describing: error), privacy: .public)")
				}
            }
        })
    }

    func setAPIKey(_ key: String?) {
        self.hasAPIKey = key != nil

        if key == nil {
            Task {
                self.keyStore.saveAPIKey(key)
            }
            self.accounts = []
        } else {
            Task {
                self.keyStore.saveAPIKey(key)
            }
        }
    }

    func getAccountInfo() async throws {
        guard keyStore.getAPIKey() != nil else {
            setAPIKey(nil)
            return
        }

        let decoder = JSONDecoder()

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.modulbank.ru"
        components.path = "/v1/account-info"

        guard let url = components.url else {
            throw APIError.badURL
        }

		logger.info("Getting data")
        let request = makeRequest(withMethod: .POST, fromURL: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode([AccountInfo].self, from: data)
		await MainActor.run {
			self.accounts = response
		}
    }

    private func makeRequest(withMethod method: HTTPMethod, fromURL url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        if let apiKey = keyStore.getAPIKey() {
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
