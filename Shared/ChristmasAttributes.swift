import Foundation
import ActivityKit

// Shared Codable state. The extension renders from this snapshot without a server.
struct ChristmasAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var theme: ChristmasTheme
        var mood: ChristmasMood
        var scene: NorthPoleScene
        var startedAt: Date
        var eventUntil: Date
    }
    var christmasDate: Date
}

enum ChristmasTheme: String, Codable, CaseIterable, Identifiable {
    case santa, rudolph, snowman, gingerbread, aurora, penguin

    var id: String { rawValue }
    var title: String {
        switch self {
        case .santa: return "Santa Express"
        case .rudolph: return "Rudolph's Run"
        case .snowman: return "Frosty Nights"
        case .gingerbread: return "Sugar Rush"
        case .aurora: return "Northern Lights"
        case .penguin: return "Polar Party"
        }
    }
    var emoji: String {
        switch self {
        case .santa: return "🎅"
        case .rudolph: return "🦌"
        case .snowman: return "☃️"
        case .gingerbread: return "🍪"
        case .aurora: return "🌌"
        case .penguin: return "🐧"
        }
    }
    var subtitle: String {
        switch self {
        case .santa: return "Sleighs across the skyline"
        case .rudolph: return "The red-nose express"
        case .snowman: return "A frosted little world"
        case .gingerbread: return "North Pole bakery"
        case .aurora: return "Midnight above the pines"
        case .penguin: return "Tiny Antarctic mischief"
        }
    }
}

enum ChristmasMood: String, Codable, CaseIterable, Identifiable {
    case cozy, magic, blizzard

    var id: String { rawValue }
    var title: String {
        switch self {
        case .cozy: return "Cozy"
        case .magic: return "Magic"
        case .blizzard: return "Blizzard"
        }
    }
    var subtitle: String {
        switch self {
        case .cozy: return "Soft snow"
        case .magic: return "Bright sparkle"
        case .blizzard: return "Maximum snow"
        }
    }
    var icon: String {
        switch self {
        case .cozy: return "moon.stars.fill"
        case .magic: return "sparkles"
        case .blizzard: return "cloud.snow.fill"
        }
    }
    var flakeCount: Int {
        switch self {
        case .cozy: return 34
        case .magic: return 75
        case .blizzard: return 135
        }
    }
}

enum NorthPoleScene: String, Codable, CaseIterable, Identifiable {
    case winterNight, sleighFlyby, giftShower, snowstorm, northernLights, starWish

    var id: String { rawValue }
    var title: String {
        switch self {
        case .winterNight: return "Midnight snow"
        case .sleighFlyby: return "Sleigh flyby"
        case .giftShower: return "Gift shower"
        case .snowstorm: return "Snowstorm"
        case .northernLights: return "Aurora wave"
        case .starWish: return "Make a wish"
        }
    }
    var icon: String {
        switch self {
        case .winterNight: return "🌙"
        case .sleighFlyby: return "🛷"
        case .giftShower: return "🎁"
        case .snowstorm: return "❄️"
        case .northernLights: return "🌌"
        case .starWish: return "🌟"
        }
    }
    var caption: String {
        switch self {
        case .winterNight: return "The North Pole is glowing"
        case .sleighFlyby: return "Santa spotted above the clouds"
        case .giftShower: return "Special delivery incoming"
        case .snowstorm: return "Whiteout at the North Pole"
        case .northernLights: return "The sky is dancing tonight"
        case .starWish: return "Your wish is on its way"
        }
    }
    var tintName: String {
        switch self {
        case .winterNight: return "midnight"
        case .sleighFlyby: return "ruby"
        case .giftShower: return "gold"
        case .snowstorm: return "ice"
        case .northernLights: return "mint"
        case .starWish: return "violet"
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

    static func progress(to date: Date, from now: Date = Date()) -> Double {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let priorChristmas = calendar.date(from: DateComponents(year: year - 1, month: 12, day: 25)) ?? now
        let total = date.timeIntervalSince(priorChristmas)
        guard total > 0 else { return 1 }
        return min(1, max(0, now.timeIntervalSince(priorChristmas) / total))
    }
}