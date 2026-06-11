// MARK: - Home

struct HomeView: View {
    @EnvironmentObject private var store: AppStore
    let onStart: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DecorativeAsset(
                        name: "app_logoFB",
                        fallbackEmoji: "🐯",
                        height: 180
                    )

                    EastCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome, Traveler")
                                .font(.title2.bold())

                            Text("Your balance: \(store.currentBalance.money)")
                                .font(.headline)
                                .foregroundStyle(AppTheme.gold)
                        }
                        .foregroundStyle(.white)
                    }

                    OmikujiCard(wisdom: store.todayWisdom)

                    Button {
                        onStart()
                    } label: {
                        Label("Start Path", systemImage: "figure.walk")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.jade)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    ResponsibleGamingCard()
                }
                .padding()
            }
            .navigationTitle("Inner Courtyard")
            .background(AppTheme.background.ignoresSafeArea())
        }
    }
}

struct OmikujiCard: View {
    let wisdom: Wisdom
    @State private var isOpen = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isOpen.toggle()
            }
        } label: {
            EastCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Daily Omikuji")
                            .font(.headline)

                        Spacer()

                        Image(systemName: isOpen ? "chevron.up" : "chevron.down")
                    }

                    if isOpen {
                        Text(wisdom.text)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    } else {
                        HStack {
                            DecorativeAsset(
                                name: "omikuji_folded",
                                fallbackEmoji: "🧧",
                                height: 80
                            )

                            Text("Tap to unfold today’s wisdom.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
    }
}
