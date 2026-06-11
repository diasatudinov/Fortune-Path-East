//
//  FPMenuView.swift
//  Fortune Path East
//
//

import SwiftUI

struct FPMenuView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView {
                selectedTab = 1
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            SessionSetupView()
                .tabItem {
                    Label("Path", systemImage: "timer")
                }
                .tag(1)

            ArchiveView()
                .tabItem {
                    Label("Archive", systemImage: "scroll.fill")
                }
                .tag(2)

            WisdomLibraryView()
                .tabItem {
                    Label("Wisdom", systemImage: "book.fill")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Tea House", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
    }
}

#Preview {
    FPMenuView()
        .environmentObject(AppStore())
}
