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
                .frame(minWidth: 600, maxWidth: 900, minHeight: 200)
        } label: {
            Image(systemName: "m.square.fill")
                .font(.system(size: 32))
        }
        .menuBarExtraStyle(.window)

    }
}
