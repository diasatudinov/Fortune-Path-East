//
//  FPRootView.swift
//  Fortune Path East
//
//

import SwiftUI

struct FPRootView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        if store.hasSeenOnboarding {
            FPMenuView()
        } else {
            OnboardingView()
        }
    }
}

#Preview {
    FPRootView()
        .environmentObject(AppStore())
}
