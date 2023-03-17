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
//        WindowGroup {
//            ContentView(apiStore: APIStore())
//        }

        MenuBarExtra {
            ContentView(apiStore: APIStore())
        } label: {
            Image(systemName: "m.square.fill")
                .font(.system(size: 72))
        }
        .menuBarExtraStyle(.window)

    }
}
