import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var theme: ChristmasTheme = .santa
    @State private var running = false
    @State private var status = "Ready for some Christmas magic."
    @State private var busy = false

    private let cream = Color(red: 1.0, green: 0.95, blue: 0.86)
    private let evergreen = Color(red: 0.08, green: 0.30, blue: 0.25)
    private let red = Color(red: 0.77, green: 0.16, blue: 0.24)

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color(red: 0.015, green: 0.08, blue: 0.12),
                                    Color(red: 0.04, green: 0.16, blue: 0.17),
                                    Color(red: 0.07, green: 0.07, blue: 0.10)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            SnowfallView().ignoresSafeArea().allowsHitTesting(false).opacity(0.55)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    titleSection
                    christmasCard
                    islandPreview
                    themeSection
                    actionSection
                    footnote
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 42)
            }
        }
        .task { await refreshState() }
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                Text("N O E L   I S L A N D")
                    .tracking(2)
            }
            .font(.system(size: 12, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.97, green: 0.80, blue: 0.45))
            Text("Christmas, but cooler.")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
            Text("A little piece of the North Pole in your Dynamic Island")
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.66))
                .multilineTextAlignment(.center)
        }
    }

    private var christmasCard: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let target = ChristmasTime.nextChristmas(from: timeline.date)
            let days = ChristmasTime.days(until: target, from: timeline.date)
            VStack(spacing: 12) {
                HStack {
                    Text("THE CHRISTMAS COUNTDOWN")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(1.8)
                    Spacer()
                    Image(systemName: "snowflake")
                }
                .foregroundStyle(cream.opacity(0.75))
                Text("🎄")
                    .font(.system(size: 68))
                    .shadow(color: .white.opacity(0.35), radius: 20)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(days)")
                        .font(.system(size: 74, weight: .black, design: .rounded))
                    Text(days == 1 ? "DAY" : "DAYS")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                }
                .foregroundStyle(.white)
                Text("UNTIL THE MAGIC BEGINS")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .tracking(2)
                    .foregroundStyle(cream.opacity(0.85))
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(LinearGradient(colors: [red, Color(red: 0.38, green: 0.07, blue: 0.16)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(.white.opacity(0.19)))
        }
    }

    private var islandPreview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("DYNAMIC ISLAND PREVIEW", systemImage: "iphone.gen3")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(1)
                Spacer()
                Text(running ? "LIVE" : "PREVIEW")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(running ? .green : cream)
            }
            .foregroundStyle(cream.opacity(0.88))
            HStack {
                Spacer()
                HStack(spacing: 22) {
                    Text(theme.emoji)
                    Text("\(ChristmasTime.days(until: ChristmasTime.nextChristmas()))d  ❄️")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                }
                .font(.system(size: 18))
                .padding(.horizontal, 22)
                .padding(.vertical, 12)
                .background(Capsule().fill(.black))
                .overlay(Capsule().stroke(.white.opacity(0.15)))
                Spacer()
            }
            Text("The real Island appears after you press Start. Long-press it for the expanded Christmas card.")
                .font(.system(size: 12))
                .foregroundStyle(.white.opacity(0.54))
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 22).fill(.white.opacity(0.07)))
    }

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("CHOOSE YOUR CHRISTMAS MODE")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .tracking(1.2)
                .foregroundStyle(cream)
            ForEach(ChristmasTheme.allCases) { item in
                Button {
                    theme = item
                } label: {
                    HStack(spacing: 14) {
                        Text(item.emoji).font(.system(size: 29))
                            .frame(width: 44, height: 44)
                            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title).font(.system(size: 16, weight: .semibold))
                            Text(item.subtitle).font(.system(size: 12)).foregroundStyle(.white.opacity(0.56))
                        }
                        Spacer()
                        Image(systemName: theme == item ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(theme == item ? Color.green : .white.opacity(0.3))
                            .font(.system(size: 21))
                    }
                    .foregroundStyle(.white)
                    .padding(13)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 17)
                        .fill(theme == item ? evergreen.opacity(0.83) : .white.opacity(0.06)))
                    .overlay(RoundedRectangle(cornerRadius: 17).stroke(theme == item ? .green.opacity(0.45) : .white.opacity(0.08)))
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            Button {
                Task { await startChristmas() }
            } label: {
                HStack(spacing: 9) {
                    Image(systemName: "sparkles")
                    Text(running ? "RESTART CHRISTMAS ISLAND" : "START CHRISTMAS ISLAND")
                }
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .foregroundStyle(Color(red: 0.08, green: 0.20, blue: 0.16))
                .background(cream, in: RoundedRectangle(cornerRadius: 17))
            }
            .disabled(busy)

            if running {
                Button("Stop Live Activity") {
                    Task { await stopChristmas() }
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.75))
                .disabled(busy)
            }
            Text(status)
                .font(.system(size: 12))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.7))
        }
    }

    private var footnote: some View {
        VStack(spacing: 7) {
            Text("✦  MADE FOR THE IPHONE 15  ✦")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .tracking(1.8)
            Text("Apple limits each Live Activity to about 8 hours. Reopen the app to start a new one. Snow animations appear inside the app, not around the system Island.")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.white.opacity(0.43))
    }

    @MainActor
    private func refreshState() async {
        running = !Activity<ChristmasAttributes>.activities.isEmpty
        if running { status = "Christmas is running in your Dynamic Island!" }
    }

    @MainActor
    private func startChristmas() async {
        busy = true
        defer { busy = false }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            status = "Live Activities are off. Enable them in Settings → Apps → Noel Island → Live Activities."
            return
        }
        for activity in Activity<ChristmasAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        let attributes = ChristmasAttributes(christmasDate: ChristmasTime.nextChristmas())
        let state = ChristmasAttributes.ContentState(theme: theme, startedAt: Date())
        do {
            _ = try Activity.request(attributes: attributes,
                content: ActivityContent(state: state, staleDate: nil), pushType: nil)
            running = true
            status = "Live! Go to your Home Screen and long-press the Island 🎄"
        } catch {
            running = false
            status = "Couldn't start the Live Activity: \(error.localizedDescription)"
        }
    }

    @MainActor
    private func stopChristmas() async {
        busy = true
        defer { busy = false }
        for activity in Activity<ChristmasAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        running = false
        status = "Christmas Island stopped. You can restart it any time."
    }
}

private struct SnowfallView: View {
    struct Flake {
        var x: CGFloat
        var y: CGFloat
        var radius: CGFloat
        var speed: CGFloat
    }

    private let flakes: [Flake] = SnowfallView.makeFlakes()

    private static func makeFlakes() -> [Flake] {
        var result: [Flake] = []
        result.reserveCapacity(40)
        for i in 0..<40 {
            let x: CGFloat = CGFloat((i * 173 + 73) % 997) / CGFloat(997)
            let y: CGFloat = CGFloat((i * 271 + 127) % 991) / CGFloat(991)
            let radius: CGFloat = CGFloat((i % 3) + 1)
            let speed: CGFloat = CGFloat((i % 4) + 1) * CGFloat(0.012)
            result.append(Flake(x: x, y: y, radius: radius, speed: speed))
        }
        return result
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 20.0, paused: false)) { context in
            Canvas { canvas, size in
                let time = context.date.timeIntervalSinceReferenceDate
                for f in flakes {
                    let x = f.x * size.width + CGFloat(sin(time * 0.6 + Double(f.y) * 20) * 10)
                    let progress = (f.y + CGFloat(time) * f.speed).truncatingRemainder(dividingBy: 1)
                    let y = progress * size.height
                    let rect = CGRect(x: x, y: y, width: f.radius * 2, height: f.radius * 2)
                    canvas.fill(Path(ellipseIn: rect), with: .color(.white.opacity(0.5)))
                }
            }
        }
    }
}
