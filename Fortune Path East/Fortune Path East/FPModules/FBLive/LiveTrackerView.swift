//
//  LiveTrackerView.swift
//  Fortune Path East
//
//

import SwiftUI


// MARK: - Live Tracker

struct LiveTrackerView: View {
    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    @State private var eventAmount = ""
    @State private var manualBalance = ""

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            if let session = store.currentSession {
                liveContent(session)
            } else {
                VStack(spacing: 16) {
                    Text("No active session")
                        .font(.title2.bold())

                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Flow")
        .navigationBarTitleDisplayMode(.inline)
        .background(AppTheme.background.ignoresSafeArea())
        .onReceive(timer) { _ in
            store.tickLiveSession()
        }
        .alert(item: $store.activeSignal) { signal in
            Alert(
                title: Text(signal.title),
                message: Text(signal.message),
                primaryButton: .default(Text("Continue")) {
                    store.dismissSignal()
                },
                secondaryButton: .destructive(Text("End Path")) {
                    store.finishCurrentSession(reason: signal.reason)
                    dismiss()
                }
            )
        }
        .onAppear {
            if let balance = store.currentSession?.currentBalance {
                manualBalance = String(Int(balance))
            }
        }
    }

    private func liveContent(_ session: LiveSession) -> some View {
        ScrollView {
            VStack(spacing: 16) {
                TimerPanel(session: session)

                EastCard {
                    VStack(spacing: 8) {
                        Text("Current Balance")
                            .font(.headline)

                        Text(session.currentBalance.money)
                            .font(.largeTitle.bold())
                            .foregroundStyle(session.profit >= 0 ? AppTheme.jade : AppTheme.red)

                        Text("Profit: \(session.profit.money)")
                            .foregroundStyle(session.profit >= 0 ? AppTheme.jade : AppTheme.red)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                }

                EastCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Event Amount")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        TextField("Win amount / bonus buy cost", text: $eventAmount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .foregroundStyle(.black)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(SessionEventType.allCases) { type in
                                Button {
                                    let amount = Double.fromInput(eventAmount) ?? 0
                                    store.addEvent(type: type, amount: amount)

                                    if type != .regularSpin {
                                        eventAmount = ""
                                    }
                                } label: {
                                    EventButton(type: type)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                EastCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Set Exact Balance")
                            .font(.headline)

                        TextField("Current balance", text: $manualBalance)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .foregroundStyle(.black)

                        Button {
                            guard let value = Double.fromInput(manualBalance) else { return }
                            store.updateCurrentBalance(value)
                        } label: {
                            Text("Apply Balance")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppTheme.gold)
                                .foregroundStyle(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }.foregroundStyle(.white)
                }

                if !session.events.isEmpty {
                    EastCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recent Events")
                                .font(.headline)

                            ForEach(Array(session.events.suffix(5).reversed())) { event in
                                HStack {
                                    Text(event.type.title)
                                    Spacer()
                                    Text(event.resultingBalance.money)
                                        .foregroundStyle(.secondary)
                                }
                                .font(.subheadline)
                            }
                        }
                    }.foregroundStyle(.white)
                }

                Button {
                    store.finishCurrentSession(reason: .manual)
                    dismiss()
                } label: {
                    Label("Finish Path", systemImage: "stop.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.red)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding()
        }
    }
}

struct TimerPanel: View {
    let session: LiveSession

    var body: some View {
        EastCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 10)

                    Circle()
                        .trim(from: 0, to: 1 - session.progress)
                        .stroke(AppTheme.gold, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))

                    VStack(spacing: 2) {
                        Image(systemName: "hourglass")
                        Text(session.remainingSeconds.timeText)
                            .font(.caption.bold())
                    }
                }
                .frame(width: 90, height: 90)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Session Time")
                        .font(.headline)

                    Text("Stop-Loss: \(session.settings.stopLoss.money)")
                        .font(.subheadline)

                    Text("Take-Profit: \(session.settings.takeProfit.money)")
                        .font(.subheadline)
                }

                Spacer()
            }
        }.foregroundStyle(.white)
    }
}

struct EventButton: View {
    let type: SessionEventType

    var body: some View {
        VStack(spacing: 8) {
            Image(type.icon)
                .resizable()
                .scaledToFit()
                .frame(height: 70)

            Text(type.title)
                .font(.caption.bold())
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            Text(type.subtitle)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 110)
        .padding(8)
        .background(AppTheme.jade.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
