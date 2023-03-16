//
//  ModulbankInformerTests.swift
//  ModulbankInformerTests
//
//  Created by Sergei Armodin on 16.03.2023.
//

import XCTest
@testable import ModulbankInformer

final class ModelsTestsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBankAccountParsing() throws {
        let id = NSUUID().uuidString
        let jsonData = """
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
             "id": "\(id)",
             "number": "12345678901234567890",
             "status": "New"
        }
        """.data(using: .utf8)!

        var account: BankAccount?
        do {
            account = try JSONDecoder().decode(BankAccount.self, from: jsonData)
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
            return
        }

        XCTAssertEqual(account?.accountName, "Карточный счёт")
        XCTAssertEqual(account?.balance, 4917.76)
        XCTAssertEqual(account?.bankBic, "044525092")
        XCTAssertEqual(account?.bankInn, "2204000595")
        XCTAssertEqual(account?.bankKpp, "771543001")
        XCTAssertEqual(account?.bankCorrespondentAccount, "30101810645250000092")
        XCTAssertEqual(account?.bankName, "МОСКОВСКИЙ ФИЛИАЛ АО КБ МОДУЛЬБАНК")
        XCTAssertNotNil(account?.beginDate)
        XCTAssertEqual(account?.category, .checkingAccount)
        XCTAssertEqual(account?.currency, .rur)
        XCTAssertEqual(account?.id, id)
        XCTAssertEqual(account?.number, "12345678901234567890")
        XCTAssertEqual(account?.status, .new)
    }

    func testAccountInfoParsing() {
        let id = NSUUID().uuidString

        let jsonData = """
          {
            "companyId": "\(id)",
            "companyName": "ООО А А А",
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
              }
            ],
            "registrationCompleted": true,
            "Inn": "123456789012",
            "Kpp": "",
            "Ogrn": "123456789012345"
          }
        """.data(using: .utf8)!

        var accountInfo: AccountInfo?
        do {
            accountInfo = try JSONDecoder().decode(AccountInfo.self, from: jsonData)
        } catch {
            print(error)
            XCTFail(error.localizedDescription)
            return
        }

        XCTAssertEqual(accountInfo?.companyId, id)
        XCTAssertEqual(accountInfo?.companyName, "ООО А А А")
        XCTAssertFalse(accountInfo?.bankAccounts.isEmpty ?? true)
        XCTAssertTrue(accountInfo?.registrationCompleted ?? false)
        XCTAssertEqual(accountInfo?.Inn, "123456789012")
        XCTAssertEqual(accountInfo?.Kpp, "")
        XCTAssertEqual(accountInfo?.Ogrn, "123456789012345")
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
