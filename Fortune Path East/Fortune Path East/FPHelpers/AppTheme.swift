//
//  AppTheme.swift
//  Fortune Path East
//
//


import SwiftUI

// MARK: - Theme / Extensions

enum AppTheme {
    static let jade = Color(hex: 0x2E8B57)
    static let red = Color(hex: 0xC41E3A)
    static let gold = Color(hex: 0xD4AF37)
    static let background = Color.bg
    static let card = Color.black.opacity(0.5)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension Double {
    static func fromInput(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }

    var money: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0

        return formatter.string(from: NSNumber(value: self)) ?? "$\(Int(self))"
    }

    var roundedString: String {
        String(format: "%.0f", self)
    }
}

extension Int {
    var timeText: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension Date {
    var shortText: String {
        formatted(date: .abbreviated, time: .shortened)
    }
}
