//
//  ArchiveView.swift
//  Fortune Path East
//
//

import SwiftUI

// MARK: - Archive

struct ArchiveView: View {
    @EnvironmentObject private var store: AppStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if store.sessions.isEmpty {
                        EmptyStateView(
                            title: "No Sessions Yet",
                            message: "Finish your first path to see karma analytics."
                        )
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            StatCard(title: "Total ROI", value: "\(store.totalROI.roundedString)%")
                            StatCard(title: "Avg. Time", value: "\(store.averageDurationMinutes) min")
                            StatCard(title: "Grateful Ends", value: "\(store.takeProfitSuccessRate.roundedString)%")
                            StatCard(title: "Total Profit", value: store.totalProfit.money)
                        }

                        EastCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("River Flow")
                                    .font(.headline)

                                LineChart(values: store.bankrollHistory)
                                    .frame(height: 180)
                            }.foregroundStyle(.white)
                        }

                        EastCard {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Yin & Yang Balance")
                                    .font(.headline)

                                YinYangAnalyticsView(sessions: store.sessions)
                                    .frame(height: 170)
                            }.foregroundStyle(.white)
                        }

                        VStack(spacing: 12) {
                            ForEach(store.sessions) { session in
                                SessionCardView(session: session) {
                                    store.deleteSession(session)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Karma Scroll")
            .background(AppTheme.background.ignoresSafeArea())
        }
    }
}

struct SessionCardView: View {
    let session: GameSession
    let onDelete: () -> Void

    var body: some View {
        EastCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.startDate.shortText)
                            .font(.headline)

                        Text(session.endReason.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Text(session.profit.money)
                        .font(.headline)
                        .foregroundStyle(session.profit >= 0 ? AppTheme.jade : AppTheme.red)
                }

                HStack {
                    Image("archiveImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    Label("\(session.elapsedSeconds.timeText)", systemImage: "clock")
                    Spacer()
                    Label("\(session.events.count) events", systemImage: "list.bullet")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Text("Delete")
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }.foregroundStyle(.white)
        }
    }
}
