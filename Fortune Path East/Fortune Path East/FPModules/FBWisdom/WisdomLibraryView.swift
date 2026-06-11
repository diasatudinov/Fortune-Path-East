//
//  WisdomLibraryView.swift
//  Fortune Path East
//
//

import SwiftUI

// MARK: - Wisdom Library

struct WisdomLibraryView: View {
    @State private var selectedWisdom: Wisdom?

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    DecorativeAsset(
                        name: "scroll_open",
                        fallbackEmoji: "📜",
                        height: 180
                    )

                    EastCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Wisdom of the East")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                            Text("Choose a scroll for your current state of mind, or draw a random piece of wisdom.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.5))
                            
                        }
                    }

                    Button {
                        selectedWisdom = WisdomBook.all.randomElement()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.title3)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Draw Random Scroll")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                
                                Text("Let the path choose wisdom for you")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.5))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundStyle(.white.opacity(0.5))
                        }
                        .padding()
                        .background(AppTheme.gold.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)

                    ForEach(WisdomCategory.allCases) { category in
                        WisdomCategoryCard(
                            category: category,
                            wisdoms: WisdomBook.all.filter { $0.category == category }
                        ) { wisdom in
                            selectedWisdom = wisdom
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Wisdom")
            .background(AppTheme.background.ignoresSafeArea())
            .sheet(item: $selectedWisdom) { wisdom in
                WisdomDetailView(wisdom: wisdom)
            }
        }
    }
}

struct WisdomCategoryCard: View {
    let category: WisdomCategory
    let wisdoms: [Wisdom]
    let onSelect: (Wisdom) -> Void

    var body: some View {
        EastCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    Image(category.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .foregroundStyle(AppTheme.gold)

                    Text(category.title)
                        .font(.headline)
                        .foregroundStyle(.white.opacity(1))
                    Spacer()

                    Text("\(wisdoms.count)")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(1))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(AppTheme.gold.opacity(0.18))
                        .clipShape(Capsule())
                }

                VStack(spacing: 0) {
                    ForEach(wisdoms.indices, id: \.self) { index in
                        let wisdom = wisdoms[index]

                        Button {
                            onSelect(wisdom)
                        } label: {
                            WisdomRowView(wisdom: wisdom)
                        }
                        .buttonStyle(.plain)

                        if index < wisdoms.count - 1 {
                            Divider()
                                .padding(.leading, 44)
                        }
                    }
                }
            }
        }
    }
}

struct WisdomRowView: View {
    let wisdom: Wisdom

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("#\(wisdom.id)")
                .font(.caption.bold())
                .foregroundStyle(AppTheme.gold)
                .frame(width: 34, alignment: .leading)

            Text(wisdom.text)
                .font(.subheadline)
                .foregroundStyle(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            Spacer(minLength: 8)

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.5))
                .padding(.top, 3)
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

struct WisdomDetailView: View {
    let wisdom: Wisdom
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                DecorativeAsset(
                    name: "scroll_open",
                    fallbackEmoji: "📜",
                    height: 220
                )

                Text(wisdom.category.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white.opacity(1))
                
                Text("“\(wisdom.text)”")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(1))
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()
            }
            .padding()
            .navigationTitle("Scroll #\(wisdom.id)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .background(AppTheme.background.ignoresSafeArea())
        }
    }
}
