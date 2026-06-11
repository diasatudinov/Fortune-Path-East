// MARK: - Models

struct SessionSettings: Codable, Equatable {
    var startingBalance: Double
    var stopLoss: Double
    var takeProfit: Double
    var durationMinutes: Int

    var durationSeconds: Int {
        durationMinutes * 60
    }
}

struct LiveSession: Identifiable {
    let id = UUID()
    let startDate = Date()
    let settings: SessionSettings

    var currentBalance: Double
    var elapsedSeconds: Int = 0
    var events: [SessionEvent] = []

    init(settings: SessionSettings) {
        self.settings = settings
        self.currentBalance = settings.startingBalance
    }

    var profit: Double {
        currentBalance - settings.startingBalance
    }

    var remainingSeconds: Int {
        max(settings.durationSeconds - elapsedSeconds, 0)
    }

    var progress: Double {
        guard settings.durationSeconds > 0 else { return 0 }
        return min(Double(elapsedSeconds) / Double(settings.durationSeconds), 1)
    }
}

struct GameSession: Identifiable, Codable, Equatable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let settings: SessionSettings
    let events: [SessionEvent]
    let finalBalance: Double
    let elapsedSeconds: Int
    let endReason: EndReason

    init(
        id: UUID = UUID(),
        startDate: Date,
        endDate: Date,
        settings: SessionSettings,
        events: [SessionEvent],
        finalBalance: Double,
        elapsedSeconds: Int,
        endReason: EndReason
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.settings = settings
        self.events = events
        self.finalBalance = finalBalance
        self.elapsedSeconds = elapsedSeconds
        self.endReason = endReason
    }

    var profit: Double {
        finalBalance - settings.startingBalance
    }
}

struct SessionEvent: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let type: SessionEventType
    let amount: Double
    let resultingBalance: Double

    init(
        id: UUID = UUID(),
        date: Date,
        type: SessionEventType,
        amount: Double,
        resultingBalance: Double
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.amount = amount
        self.resultingBalance = resultingBalance
    }
}

enum SessionEventType: String, Codable, CaseIterable, Identifiable {
    case regularSpin
    case bonusGame
    case bigWin
    case bonusBuy

    var id: String { rawValue }

    var title: String {
        switch self {
        case .regularSpin:
            return "Regular Spin"
        case .bonusGame:
            return "Bonus / Free Spins"
        case .bigWin:
            return "Big Win / Jackpot"
        case .bonusBuy:
            return "Bonus Buy"
        }
    }

    var subtitle: String {
        switch self {
        case .regularSpin:
            return "Base game"
        case .bonusGame:
            return "Special round"
        case .bigWin:
            return "Rare event"
        case .bonusBuy:
            return "Conscious risk"
        }
    }

    var icon: String {
        switch self {
        case .regularSpin:
            return "wind"
        case .bonusGame:
            return "lantern"
        case .bigWin:
            return "dragon"
        case .bonusBuy:
            return "banknote"
        }
    }

    func balanceDelta(amount: Double) -> Double {
        switch self {
        case .regularSpin:
            return 0
        case .bonusGame, .bigWin:
            return amount
        case .bonusBuy:
            return -amount
        }
    }
}

enum EndReason: String, Codable, Hashable {
    case manual
    case takeProfit
    case stopLoss
    case timeExpired

    var title: String {
        switch self {
        case .manual:
            return "Path Completed"
        case .takeProfit:
            return "The Cup Is Full"
        case .stopLoss:
            return "The Boundary Has Been Reached"
        case .timeExpired:
            return "The Hourglass Is Empty"
        }
    }
}

struct SessionSignal: Identifiable {
    let id = UUID()
    let reason: EndReason

    var title: String {
        reason.title
    }

    var message: String {
        switch reason {
        case .manual:
            return "Your path has been recorded."
        case .takeProfit:
            return "Your Take-Profit goal has been reached. Wisdom: “Know the measure. A cup filled beyond its edge spills wine onto the ground.”"
        case .stopLoss:
            return "Your Stop-Loss boundary has been reached. Wisdom: “A boundary is not a prison, but the wall of your temple.”"
        case .timeExpired:
            return "Your planned time has ended. Wisdom: “True victory is the ability to close the game when time has passed.”"
        }
    }
}

// MARK: - Wisdom

enum WisdomCategory: String, Codable, CaseIterable, Identifiable {
    case tilt
    case greed
    case patience
    case luck
    case discipline

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tilt:
            return "Anger & Tilt"
        case .greed:
            return "Greed"
        case .patience:
            return "Patience"
        case .luck:
            return "Nature of Luck"
        case .discipline:
            return "Discipline"
        }
    }

    var icon: String {
        switch self {
        case .tilt:
            return "wind"
        case .greed:
            return "lantern"
        case .patience:
            return "dragon"
        case .luck:
            return "banknote"
        case .discipline:
            return "lantern"
        }
    }
}

struct Wisdom: Identifiable, Codable, Equatable {
    let id: Int
    let category: WisdomCategory
    let text: String
}

enum WisdomBook {
    static let all: [Wisdom] = [
        Wisdom(id: 1, category: .tilt, text: "Anger is the wind that blows out the candle of reason. Wait for stillness before placing the next bet."),
        Wisdom(id: 2, category: .tilt, text: "The one who tries to catch a falling sword loses a hand. Step away and return another day."),
        Wisdom(id: 3, category: .tilt, text: "The river does not return the water that has passed. Look forward to new shores."),
        Wisdom(id: 4, category: .tilt, text: "Chasing losses is like drinking salt water: the more you drink, the stronger the thirst becomes."),

        Wisdom(id: 5, category: .greed, text: "Know the measure. A cup filled beyond its edge spills wine onto the ground."),
        Wisdom(id: 6, category: .greed, text: "Luck is a guest. Welcome her when she comes, but do not try to lock her in your house."),
        Wisdom(id: 7, category: .greed, text: "A greedy player is like a monkey with a fist full of nuts, unable to pull the hand from the jar."),
        Wisdom(id: 8, category: .greed, text: "Gold won today belongs to tomorrow only if you carry it away."),

        Wisdom(id: 9, category: .patience, text: "The river does not hurry, yet it always reaches the ocean. Do not rush events by raising the stake."),
        Wisdom(id: 10, category: .patience, text: "The lotus does not bloom because you pull its petals. Let time do its work."),
        Wisdom(id: 11, category: .patience, text: "Empty reels are not the absence of luck, but the space where luck prepares to be born."),
        Wisdom(id: 12, category: .patience, text: "The master does not strike the stone a hundred times. He waits, then makes one precise strike."),

        Wisdom(id: 13, category: .luck, text: "Dice do not remember how they fell yesterday. Every throw is born from emptiness."),
        Wisdom(id: 14, category: .luck, text: "Luck is not a spirit to please. It is the rhythm of rain: storm and drought. Build a roof, not a dance."),
        Wisdom(id: 15, category: .luck, text: "The house always takes its share. Accept the price of entertainment and keep your peace."),
        Wisdom(id: 16, category: .luck, text: "The illusion of control is the most dangerous demon. You do not command the wind; you adjust the sails."),

        Wisdom(id: 17, category: .discipline, text: "A boundary is not a prison, but the wall of your temple, protecting you from wild beasts."),
        Wisdom(id: 18, category: .discipline, text: "The one who does not know when to leave eventually walks home without shoes."),
        Wisdom(id: 19, category: .discipline, text: "True victory is not the jackpot, but the ability to close the game when time has passed."),
        Wisdom(id: 20, category: .discipline, text: "Your bankroll is your life force. Do not scatter it into the wind of excitement.")
    ]
}