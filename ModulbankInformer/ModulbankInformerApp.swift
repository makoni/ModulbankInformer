//
//  ModulbankInformerApp.swift
//  ModulbankInformer
//
//  Created by Sergei Armodin on 16.03.2023.
//

import SwiftUI


@main
struct ModulbankInformerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(apiStore: APIStore())
        }

//        MenuBarExtra("a", systemImage: "m.circle") {
//            ContentView(apiStore: APIStore())
//        }
    }
}
