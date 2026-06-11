//
//  Fortune_Path_EastApp.swift
//  Fortune Path East
//
//

import SwiftUI

@main
struct Fortune_Path_EastApp: App {
    var body: some Scene {
        WindowGroup {
            FPRootView()
                .environmentObject(AppStore())
        }
    }
}
