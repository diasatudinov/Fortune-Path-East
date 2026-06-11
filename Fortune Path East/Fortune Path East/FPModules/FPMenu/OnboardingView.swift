//
//  OnboardingView.swift
//  Fortune Path East
//
//

import SwiftUI

// MARK: - Onboarding

struct OnboardingView: View {
    @EnvironmentObject private var store: AppStore
    @State private var page = 0

    private let pages = [
        OnboardingPage(
            title: "Boundaries of the Path",
            subtitle: "Set your Stop-Loss, Take-Profit and session time before entering the river.",
            assetName: "onboarding_limits",
            fallbackEmoji: "⛩️"
        ),
        OnboardingPage(
            title: "River Flow",
            subtitle: "Track spins, bonuses, big wins and bonus buys during any game session.",
            assetName: "onboarding_river",
            fallbackEmoji: "🌊"
        ),
        OnboardingPage(
            title: "Wisdom Scrolls",
            subtitle: "Receive calm reminders when greed, tilt or chasing losses appear.",
            assetName: "onboarding_wisdom",
            fallbackEmoji: "📜"
        )
    ]

    var body: some View {
        ZStack {
            Image(.onbBg)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                TabView(selection: $page) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack(spacing: 28) {
                            ZStack {
                                Image(pages[index].assetName)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                            }
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                            VStack(spacing: 12) {
                                Text(pages[index].title)
                                    .font(.largeTitle.bold())
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                
                                Text(pages[index].subtitle)
                                    .font(.body)
                                    .foregroundStyle(.white.opacity(0.5))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 24)
                            }
                            .padding()
                            .background(AppTheme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            
                                
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                
                Button {
                    if page < pages.count - 1 {
                        withAnimation {
                            page += 1
                        }
                    } else {
                        store.completeOnboarding()
                    }
                } label: {
                    Text(page == pages.count - 1 ? "Start Your Path" : "Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.jade)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let subtitle: String
    let assetName: String
    let fallbackEmoji: String
}
