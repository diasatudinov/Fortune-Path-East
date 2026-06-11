// MARK: - Profile

struct ProfileView: View {
    @EnvironmentObject private var store: AppStore
    @State private var showClearConfirmation = false

    private var rank: Rank {
        Rank.rank(for: store.sessions.count)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    DecorativeAsset(
                        name: rank.assetName,
                        fallbackEmoji: "🐯",
                        height: 220
                    )

                    EastCard {
                        VStack(spacing: 12) {
                            Text(rank.title)
                                .font(.title.bold())

                            Text("\(store.sessions.count) sessions completed")
                                .foregroundStyle(.secondary)

                            ProgressView(value: rank.progress(for: store.sessions.count))
                                .tint(AppTheme.gold)

                            Text(rank.nextGoalText(for: store.sessions.count))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }.foregroundStyle(.white)
                    }

                    EastCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Profile Stats")
                                .font(.headline)

                            MetricRow(title: "Total Profit", value: store.totalProfit.money)
                            MetricRow(title: "Average Duration", value: "\(store.averageDurationMinutes) min")
                            MetricRow(title: "Take-Profit Ends", value: "\(store.takeProfitSuccessRate.roundedString)%")
                        }.foregroundStyle(.white)
                    }

                    ResponsibleGamingCard()

                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        Text("Clear Session History")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.red.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding()
            }
            .navigationTitle("Tea House")
            .background(AppTheme.background.ignoresSafeArea())
            .confirmationDialog("Clear all sessions?", isPresented: $showClearConfirmation) {
                Button("Clear", role: .destructive) {
                    store.clearHistory()
                }

                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

enum Rank {
    case student
    case adept
    case master
    case sage

    static func rank(for sessions: Int) -> Rank {
        switch sessions {
        case 0...10:
            return .student
        case 11...30:
            return .adept
        case 31...80:
            return .master
        default:
            return .sage
        }
    }

    var title: String {
        switch self {
        case .student:
            return "Student"
        case .adept:
            return "Adept"
        case .master:
            return "Master"
        case .sage:
            return "Sage"
        }
    }

    var assetName: String {
        switch self {
        case .student:
            return "rank_student"
        case .adept:
            return "rank_adept"
        case .master:
            return "rank_master"
        case .sage:
            return "rank_sage"
        }
    }

    func progress(for sessions: Int) -> Double {
        switch self {
        case .student:
            return Double(sessions) / 11
        case .adept:
            return Double(sessions - 11) / 20
        case .master:
            return Double(sessions - 31) / 50
        case .sage:
            return 1
        }
    }

    func nextGoalText(for sessions: Int) -> String {
        switch self {
        case .student:
            return "\(max(11 - sessions, 0)) sessions to Adept"
        case .adept:
            return "\(max(31 - sessions, 0)) sessions to Master"
        case .master:
            return "\(max(81 - sessions, 0)) sessions to Sage"
        case .sage:
            return "You have reached the highest rank"
        }
    }
}