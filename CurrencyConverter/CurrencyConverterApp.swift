//
//  CurrencyConverterApp.swift
//  CurrencyConverter
//
//  Created by Linkon Sid on 8/10/22.
//

import SwiftUI

@main
struct CurrencyConverterApp: App {
    @Environment(\.scenePhase) private var phase
    var body: some Scene {
        WindowGroup {
            ConverterView().configure()
        }
    }
}
