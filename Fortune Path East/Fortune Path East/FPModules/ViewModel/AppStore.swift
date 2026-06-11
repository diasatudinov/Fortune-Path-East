//
//  FortunePathEastApp.swift
//  Fortune Path East
//
//


import SwiftUI
import Foundation

// MARK: - App Store

final class AppStore: ObservableObject {
    @Published var hasSeenOnboarding: Bool {
        didSet {
            UserDefaults.standard.set(hasSeenOnboarding, forKey: Keys.hasSeenOnboarding)
        }
    }

    @Published private(set) var sessions: [GameSession] {
        didSet {
            saveSessions()
        }
    }

    @Published var currentSession: LiveSession?
    @Published var activeSignal: SessionSignal?

    private var shownSignals = Set<EndReason>()

    init() {
        self.hasSeenOnboarding = UserDefaults.standard.bool(forKey: Keys.hasSeenOnboarding)
        self.sessions = Self.loadSessions()
    }

    var currentBalance: Double {
        currentSession?.currentBalance ?? sessions.first?.finalBalance ?? 0
    }

    var totalProfit: Double {
        sessions.reduce(0) { $0 + $1.profit }
    }

    var totalROI: Double {
        let totalStart = sessions.reduce(0) { $0 + $1.settings.startingBalance }
        guard totalStart > 0 else { return 0 }
        return totalProfit / totalStart * 100
    }

    var averageDurationMinutes: Int {
        guard !sessions.isEmpty else { return 0 }
        let totalSeconds = sessions.reduce(0) { $0 + $1.elapsedSeconds }
        return totalSeconds / sessions.count / 60
    }

    var takeProfitSuccessRate: Double {
        guard !sessions.isEmpty else { return 0 }
        let successCount = sessions.filter { $0.endReason == .takeProfit }.count
        return Double(successCount) / Double(sessions.count) * 100
    }

    var bankrollHistory: [Double] {
        let ordered = sessions.reversed()
        var result: [Double] = []

        for session in ordered {
            if result.isEmpty {
                result.append(session.settings.startingBalance)
            }
            result.append(session.finalBalance)
        }

        return result.isEmpty ? [0] : result
    }

    var todayWisdom: Wisdom {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return WisdomBook.all[day % WisdomBook.all.count]
    }

    func completeOnboarding() {
        hasSeenOnboarding = true
    }

    func startSession(settings: SessionSettings) {
        currentSession = LiveSession(settings: settings)
        activeSignal = nil
        shownSignals.removeAll()
    }

    func tickLiveSession() {
        guard var session = currentSession else { return }

        session.elapsedSeconds = min(
            session.elapsedSeconds + 1,
            session.settings.durationSeconds
        )

        currentSession = session
        checkSignals()
    }

    func addEvent(type: SessionEventType, amount: Double) {
        guard var session = currentSession else { return }

        let delta = type.balanceDelta(amount: amount)
        session.currentBalance += delta

        let event = SessionEvent(
            date: Date(),
            type: type,
            amount: amount,
            resultingBalance: session.currentBalance
        )

        session.events.append(event)
        currentSession = session

        checkSignals()
    }

    func updateCurrentBalance(_ balance: Double) {
        guard var session = currentSession else { return }
        session.currentBalance = balance
        currentSession = session

        checkSignals()
    }

    func finishCurrentSession(reason: EndReason = .manual) {
        guard let session = currentSession else { return }

        let finishedSession = GameSession(
            startDate: session.startDate,
            endDate: Date(),
            settings: session.settings,
            events: session.events,
            finalBalance: session.currentBalance,
            elapsedSeconds: session.elapsedSeconds,
            endReason: reason
        )

        sessions.insert(finishedSession, at: 0)
        currentSession = nil
        activeSignal = nil
        shownSignals.removeAll()
    }

    func dismissSignal() {
        activeSignal = nil
    }

    func deleteSession(_ session: GameSession) {
        sessions.removeAll { $0.id == session.id }
    }

    func clearHistory() {
        sessions.removeAll()
    }

    private func checkSignals() {
        guard activeSignal == nil else { return }
        guard let session = currentSession else { return }

        let reason: EndReason?

        if session.profit >= session.settings.takeProfit {
            reason = .takeProfit
        } else if session.profit <= -session.settings.stopLoss {
            reason = .stopLoss
        } else if session.elapsedSeconds >= session.settings.durationSeconds {
            reason = .timeExpired
        } else {
            reason = nil
        }

        guard let reason else { return }
        guard !shownSignals.contains(reason) else { return }

        shownSignals.insert(reason)
        activeSignal = SessionSignal(reason: reason)
    }

    private func saveSessions() {
        guard let data = try? JSONEncoder().encode(sessions) else { return }
        UserDefaults.standard.set(data, forKey: Keys.sessions)
    }

    private static func loadSessions() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: Keys.sessions) else {
            return []
        }

        return (try? JSONDecoder().decode([GameSession].self, from: data)) ?? []
    }

    private enum Keys {
        static let hasSeenOnboarding = "fortune_path_has_seen_onboarding_real"
        static let sessions = "fortune_path_sessions"
    }
}


 



