import Foundation
import ActivityKit

/// Data used in both the app and its Dynamic Island extension.
struct ChristmasAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var theme: ChristmasTheme
        var startedAt: Date
    }

    var christmasDate: Date
}

enum ChristmasTheme: String, Codable, CaseIterable, Identifiable {
    case santa, rudolph, snowman, gingerbread

    var id: String { rawValue }
    var title: String {
        switch self {
        case .santa: return "Santa's Sleigh"
        case .rudolph: return "Rudolph Express"
        case .snowman: return "Snowfall Mode"
        case .gingerbread: return "Gingerbread Town"
        }
    }
    var emoji: String {
        switch self {
        case .santa: return "🎅"
        case .rudolph: return "🦌"
        case .snowman: return "☃️"
        case .gingerbread: return "🍪"
        }
    }
    var subtitle: String {
        switch self {
        case .santa: return "Sleigh launch countdown"
        case .rudolph: return "North Pole delivery crew"
        case .snowman: return "Let it snow!"
        case .gingerbread: return "Fresh from the North Pole"
        }
    }
}

enum ChristmasTime {
    static func nextChristmas(from date: Date = Date()) -> Date {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let target = calendar.date(from: DateComponents(year: year, month: 12, day: 25))!
        if date < target || calendar.isDate(date, inSameDayAs: target) { return target }
        return calendar.date(from: DateComponents(year: year + 1, month: 12, day: 25))!
    }

    static func days(until date: Date, from now: Date = Date()) -> Int {
        max(0, Calendar.current.dateComponents([.day],
            from: Calendar.current.startOfDay(for: now),
            to: Calendar.current.startOfDay(for: date)).day ?? 0)
    }
}
