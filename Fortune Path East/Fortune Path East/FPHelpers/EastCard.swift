// MARK: - Reusable UI

struct EastCard<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.card)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
    }
}

struct DecorativeAsset: View {
    let name: String
    let fallbackEmoji: String
    let height: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(AppTheme.card)
            
            Image(name)
                .resizable()
                .scaledToFit()
                .padding()
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        EastCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.headline)
            }.foregroundStyle(.white)
        }
    }
}

struct MetricRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        EastCard {
            VStack(spacing: 12) {
                Image(systemName: "scroll")
                    .font(.largeTitle)
                    .foregroundStyle(AppTheme.gold)

                Text(title)
                    .font(.title3.bold())

                Text(message)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
        }
    }
}

struct ResponsibleGamingCard: View {
    var body: some View {
        EastCard {
            VStack(alignment: .leading, spacing: 8) {
                Label("Responsible Play", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(AppTheme.gold)

                Text("This app is a personal tracker and self-regulation tool. It is not a casino, does not connect to real gambling services and does not guarantee winnings. Set limits and stop when play stops being enjoyable.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .foregroundStyle(.white)
        }
    }
}