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
        MenuBarExtra {
            ContentView(apiStore: APIStore())
        } label: {
            let configuration = NSImage.SymbolConfiguration(pointSize: 16, weight: .light)
                let image = NSImage(systemSymbolName: "m.circle.fill", accessibilityDescription: nil)
                let updateImage = image?.withSymbolConfiguration(configuration)
                Image(nsImage: updateImage!)
        }
        .menuBarExtraStyle(.window)
    }
}
