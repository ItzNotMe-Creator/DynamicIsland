import SwiftUI
import WidgetKit
import ActivityKit

@main
struct NoelIslandWidgetBundle: WidgetBundle {
    var body: some Widget {
        ChristmasLiveActivity()
    }
}

struct ChristmasLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ChristmasAttributes.self) { context in
            NoelLockScreenCard(context: context)
                .activityBackgroundTint(Color(red: 0.04, green: 0.10, blue: 0.18))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 5) {
                        Text(context.state.theme.emoji)
                            .font(.system(size: 22))
                        Text("NOEL")
                            .font(.system(size: 11, weight: .black, design: .rounded))
                            .tracking(1)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text("\(ChristmasTime.days(until: context.attributes.christmasDate))")
                            .font(.system(size: 23, weight: .black, design: .rounded))
                            .monospacedDigit()
                        Text("DAYS")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundStyle(NoelIslandColors.mint)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("✦ NORTH POLE LIVE ✦")
                        .font(.system(size: 9, weight: .heavy, design: .rounded))
                        .foregroundStyle(NoelIslandColors.mint)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    NoelExpandedScene(context: context)
                }
            } compactLeading: {
                NoelCompactLeading(context: context)
            } compactTrailing: {
                NoelCompactMotion(context: context)
            } minimal: {
                Image(systemName: "cloud.snow.fill")
                    .foregroundStyle(.cyan)
            }
            .keylineTint(NoelIslandColors.accent(for: context.state.scene))
        }
    }
}

// The small Island always displays snow, while Apple's date-driven views
// advance automatically without forcing frequent background app refreshes.
private struct NoelCompactLeading: View {
    let context: ActivityViewContext<ChristmasAttributes>

    var body: some View {
        HStack(spacing: 2) {
            Text(context.state.theme.emoji)
                .font(.system(size: 14))
            Image(systemName: "cloud.snow.fill")
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(.cyan)
            Text("\(ChristmasTime.days(until: context.attributes.christmasDate))d")
                .font(.system(size: 9, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
    }
}

private struct NoelCompactMotion: View {
    let context: ActivityViewContext<ChristmasAttributes>

    private var eventInterval: ClosedRange<Date> {
        context.state.startedAt...context.state.eventUntil
    }

    var body: some View {
        VStack(spacing: 2) {
            HStack(spacing: 3) {
                Image(systemName: "snowflake")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.cyan)
                Text(timerInterval: eventInterval, countsDown: true, showsHours: false)
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .frame(width: 36, alignment: .trailing)
                    .contentTransition(.numericText(countsDown: true))
            }
            ProgressView(timerInterval: eventInterval, countsDown: true)
                .progressViewStyle(.linear)
                .tint(.cyan)
                .frame(width: 45, height: 2)
        }
    }
}

private enum NoelIslandColors {
    static let mint = Color(red: 0.54, green: 0.94, blue: 0.77)
    static let cream = Color(red: 0.98, green: 0.95, blue: 0.87)

    static func accent(for scene: NorthPoleScene) -> Color {
        switch scene {
        case .winterNight: return .cyan
        case .sleighFlyby: return .red
        case .giftShower: return .yellow
        case .snowstorm: return .white
        case .northernLights: return mint
        case .starWish: return Color(red: 0.85, green: 0.62, blue: 1)
        }
    }

    static func sky(for scene: NorthPoleScene) -> [Color] {
        switch scene {
        case .winterNight:
            return [Color(red: 0.05, green: 0.14, blue: 0.27), Color(red: 0.10, green: 0.26, blue: 0.35)]
        case .sleighFlyby:
            return [Color(red: 0.29, green: 0.07, blue: 0.19), Color(red: 0.12, green: 0.23, blue: 0.35)]
        case .giftShower:
            return [Color(red: 0.29, green: 0.20, blue: 0.07), Color(red: 0.08, green: 0.28, blue: 0.25)]
        case .snowstorm:
            return [Color(red: 0.12, green: 0.24, blue: 0.34), Color(red: 0.27, green: 0.46, blue: 0.51)]
        case .northernLights:
            return [Color(red: 0.05, green: 0.26, blue: 0.24), Color(red: 0.21, green: 0.12, blue: 0.37)]
        case .starWish:
            return [Color(red: 0.20, green: 0.10, blue: 0.36), Color(red: 0.10, green: 0.24, blue: 0.34)]
        }
    }
}

// WidgetKit permits brief transitions when an activity is updated, but does
// not run an unrestricted snow animation continuously in Dynamic Island.
private struct NoelExpandedScene: View {
    let context: ActivityViewContext<ChristmasAttributes>

    var body: some View {
        VStack(spacing: 7) {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(
                        LinearGradient(
                            colors: NoelIslandColors.sky(for: context.state.scene),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                NoelSnowArtwork(mood: context.state.mood)
                    .padding(4)
                HStack {
                    Spacer()
                    Circle()
                        .fill(.white.opacity(0.88))
                        .frame(width: 29, height: 29)
                        .shadow(color: .white.opacity(0.5), radius: 8)
                        .padding(.trailing, 24)
                        .padding(.top, 11)
                }
                .frame(maxHeight: .infinity, alignment: .top)

                VStack(alignment: .leading, spacing: 4) {
                    Text(context.state.scene.icon)
                        .font(.system(size: 24))
                    Text(context.state.scene.title.uppercased())
                        .font(.system(size: 12, weight: .black, design: .rounded))
                        .tracking(0.8)
                    Text(context.state.scene.caption)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(12)
            }
            .frame(height: 114)

            HStack(spacing: 7) {
                Image(systemName: context.state.mood.icon)
                    .foregroundStyle(NoelIslandColors.mint)
                Text(context.state.mood.title.uppercased())
                Spacer()
                Text(context.state.theme.title)
                    .lineLimit(1)
            }
            .font(.system(size: 10, weight: .heavy, design: .rounded))
            .foregroundStyle(NoelIslandColors.cream)
            .padding(.horizontal, 5)
        }
        .padding(.horizontal, 2)
    }
}

private struct NoelSnowArtwork: View {
    let mood: ChristmasMood

    var body: some View {
        Canvas { painter, canvasSize in
            let count = mood == .cozy ? 12 : (mood == .magic ? 25 : 44)
            for index in 0..<count {
                let x = CGFloat((index * 43 + 19) % 97) / 97 * canvasSize.width
                let y = CGFloat((index * 59 + 11) % 89) / 89 * canvasSize.height
                let radius = CGFloat(index % 3 + 1)
                let spot = CGRect(x: x, y: y, width: radius * 1.8, height: radius * 1.8)
                painter.fill(Path(ellipseIn: spot), with: .color(.white.opacity(0.72)))
            }
        }
    }
}

private struct NoelLockScreenCard: View {
    let context: ActivityViewContext<ChristmasAttributes>

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 17)
                    .fill(
                        LinearGradient(
                            colors: NoelIslandColors.sky(for: context.state.scene),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Text(context.state.scene.icon)
                    .font(.system(size: 32))
            }
            .frame(width: 66, height: 66)

            VStack(alignment: .leading, spacing: 4) {
                Text("✦ NOEL ISLAND / LIVE")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .foregroundStyle(NoelIslandColors.mint)
                Text(context.state.scene.title)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                Text(context.state.scene.caption)
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
            }
            Spacer(minLength: 4)
            VStack(spacing: 0) {
                Text("\(ChristmasTime.days(until: context.attributes.christmasDate))")
                    .font(.system(size: 31, weight: .black, design: .rounded))
                    .monospacedDigit()
                Text("DAYS")
                    .font(.system(size: 9, weight: .black, design: .rounded))
            }
            .foregroundStyle(.white)
        }
        .padding(13)
    }
}
