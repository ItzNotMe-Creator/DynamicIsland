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
            lockScreenCard(context: context)
                .activityBackgroundTint(Color(red: 0.10, green: 0.19, blue: 0.16))
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.theme.emoji)
                        .font(.system(size: 29))
                        .padding(.leading, 3)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(ChristmasTime.days(until: context.attributes.christmasDate))")
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                        Text("DAYS")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.green)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 2) {
                        Text("🎄 NORTH POLE LIVE")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundStyle(.green)
                        Text(context.state.theme.title)
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(spacing: 7) {
                        HStack {
                            Text("❄️")
                            Spacer()
                            Text("🎁")
                            Spacer()
                            Text("🦌")
                            Spacer()
                            Text("🎄")
                        }
                        .font(.system(size: 18))
                        Capsule()
                            .fill(LinearGradient(colors: [.red, .green], startPoint: .leading, endPoint: .trailing))
                            .frame(height: 4)
                        Text("The magic is getting closer ✨")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 4)
                }
            } compactLeading: {
                Text(context.state.theme.emoji)
                    .font(.system(size: 17))
            } compactTrailing: {
                HStack(spacing: 2) {
                    Text("\(ChristmasTime.days(until: context.attributes.christmasDate))d")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                    Image(systemName: "snowflake")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.cyan)
                }
            } minimal: {
                Text(context.state.theme.emoji)
            }
            .keylineTint(.green)
        }
    }

    private func lockScreenCard(context: ActivityViewContext<ChristmasAttributes>) -> some View {
        HStack(spacing: 14) {
            Text(context.state.theme.emoji).font(.system(size: 40))
            VStack(alignment: .leading, spacing: 4) {
                Text("🎄 NORTH POLE LIVE")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .tracking(1.5)
                    .foregroundStyle(.green)
                Text(context.state.theme.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("Christmas is on its way ✨")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.65))
            }
            Spacer(minLength: 8)
            VStack(spacing: 1) {
                Text("\(ChristmasTime.days(until: context.attributes.christmasDate))")
                    .font(.system(size: 33, weight: .black, design: .rounded))
                Text("DAYS")
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .tracking(1)
            }
            .foregroundStyle(.white)
        }
        .padding(14)
    }
}
