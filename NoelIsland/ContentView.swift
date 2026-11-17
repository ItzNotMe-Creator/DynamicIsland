import SwiftUI
import ActivityKit

private enum NoelPalette {
    static let background = Color(red: 0.026, green: 0.049, blue: 0.086)
    static let night = Color(red: 0.055, green: 0.10, blue: 0.18)
    static let cream = Color(red: 0.98, green: 0.94, blue: 0.83)
    static let mint = Color(red: 0.56, green: 0.94, blue: 0.79)
    static let gold = Color(red: 1.0, green: 0.77, blue: 0.40)
    static let muted = Color(red: 0.64, green: 0.72, blue: 0.76)
}

struct ContentView: View {
    @AppStorage("noel.theme") private var themeRaw = ChristmasTheme.santa.rawValue
    @AppStorage("noel.mood") private var moodRaw = ChristmasMood.magic.rawValue
    @State private var scene: NorthPoleScene = .winterNight
    @State private var running = false
    @State private var busy = false
    @State private var status = "Your North Pole is ready."
    @State private var showNightstand = false

    private var theme: ChristmasTheme { ChristmasTheme(rawValue: themeRaw) ?? .santa }
    private var mood: ChristmasMood { ChristmasMood(rawValue: moodRaw) ?? .magic }

    var body: some View {
        ZStack {
            LinearGradient(colors: [NoelPalette.background, NoelPalette.night, .black],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            AnimatedSnowView(mood: mood)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 23) {
                    header
                    HolidayHeroView(theme: theme, scene: scene)
                    islandPreview
                    themePicker
                    moodPicker
                    scenePicker
                    startControls
                    nightstandControls
                    footer
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 52)
            }
        }
        .preferredColorScheme(.dark)
        .task { await refreshState() }
        .fullScreenCover(isPresented: $showNightstand) {
            NoelNightstandView(theme: theme, mood: mood, scene: scene)
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 5) {
                Text("N O E L  /  I S L A N D")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .tracking(2.2)
                    .foregroundStyle(NoelPalette.mint)
                Text("The North Pole,")
                    .font(.system(size: 29, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                Text("in your pocket.")
                    .font(.system(size: 29, weight: .bold, design: .rounded))
                    .foregroundStyle(NoelPalette.cream)
            }
            Spacer(minLength: 5)
            VStack(spacing: 5) {
                Image(systemName: running ? "sparkles.tv.fill" : "moon.stars.fill")
                    .font(.system(size: 19))
                    .foregroundStyle(running ? NoelPalette.mint : NoelPalette.gold)
                Text(running ? "ISLAND LIVE" : "READY")
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(NoelPalette.cream)
            }
            .padding(12)
            .background(.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 16))
        }
    }

    private var islandPreview: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("LIVE ISLAND", systemImage: "iphone.gen3")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .tracking(1.6)
                Spacer()
                Text(running ? "● ACTIVE" : "○ PREVIEW")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(running ? NoelPalette.mint : NoelPalette.muted)
            }
            .foregroundStyle(NoelPalette.cream)

            HStack(spacing: 0) {
                Spacer()
                HStack(spacing: 18) {
                    Text(scene == .snowstorm ? "❄️" : theme.emoji)
                        .font(.system(size: 19))
                    VStack(alignment: .trailing, spacing: 1) {
                        Text("\(ChristmasTime.days(until: ChristmasTime.nextChristmas())) DAYS")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                        Text(scene.title.uppercased())
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(NoelPalette.mint)
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 17)
                .padding(.vertical, 11)
                .background(.black, in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.17)))
                Spacer()
            }
            Text("Long-press the real Island to enter the North Pole. Change scenes below to send a new look to it.")
                .font(.system(size: 12))
                .foregroundStyle(NoelPalette.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(17)
        .background(.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 23))
    }

    private var themePicker: some View {
        VStack(alignment: .leading, spacing: 13) {
            sectionTitle("CHRISTMAS CHARACTERS", caption: "01 / Pick your companion")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(ChristmasTheme.allCases) { item in
                        Button {
                            themeRaw = item.rawValue
                            Task { await syncActivity() }
                        } label: {
                            VStack(spacing: 7) {
                                Text(item.emoji)
                                    .font(.system(size: 38))
                                Text(item.title)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .lineLimit(1)
                            }
                            .foregroundStyle(.white)
                            .frame(width: 112, height: 109)
                            .background(theme == item ? NoelPalette.mint.opacity(0.22) : .white.opacity(0.07),
                                        in: RoundedRectangle(cornerRadius: 21))
                            .overlay(RoundedRectangle(cornerRadius: 21)
                                .stroke(theme == item ? NoelPalette.mint : .white.opacity(0.12), lineWidth: theme == item ? 1.6 : 1))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var moodPicker: some View {
        VStack(alignment: .leading, spacing: 13) {
            sectionTitle("SNOW ENGINE", caption: "02 / Choose the atmosphere")
            HStack(spacing: 9) {
                ForEach(ChristmasMood.allCases) { item in
                    Button {
                        moodRaw = item.rawValue
                        Task { await syncActivity() }
                    } label: {
                        VStack(spacing: 7) {
                            Image(systemName: item.icon)
                                .font(.system(size: 22, weight: .medium))
                            Text(item.title)
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(mood == item ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 85)
                        .background(mood == item ? NoelPalette.cream : .white.opacity(0.08),
                                    in: RoundedRectangle(cornerRadius: 17))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var scenePicker: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionTitle("NORTH POLE EVENTS", caption: "03 / Send magic to the Island")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(NorthPoleScene.allCases) { item in
                    Button {
                        scene = item
                        Task { await syncActivity() }
                    } label: {
                        HStack(spacing: 10) {
                            Text(item.icon)
                                .font(.system(size: 27))
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                                Text(item == scene ? "SELECTED" : "TAP TO ACTIVATE")
                                    .font(.system(size: 8, weight: .semibold))
                                    .foregroundStyle(item == scene ? NoelPalette.mint : NoelPalette.muted)
                            }
                            Spacer(minLength: 0)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 11)
                        .frame(height: 68)
                        .frame(maxWidth: .infinity)
                        .background(item == scene ? NoelPalette.mint.opacity(0.14) : .white.opacity(0.07),
                                    in: RoundedRectangle(cornerRadius: 17))
                        .overlay(RoundedRectangle(cornerRadius: 17)
                            .stroke(item == scene ? NoelPalette.mint.opacity(0.7) : .white.opacity(0.10)))
                    }
                    .buttonStyle(.plain)
                }
            }

            Button {
                if let randomScene = NorthPoleScene.allCases.filter({ $0 != scene }).randomElement() {
                    scene = randomScene
                    Task { await syncActivity() }
                }
            } label: {
                HStack {
                    Image(systemName: "wand.and.stars")
                    Text("SURPRISE ME")
                        .tracking(1.4)
                    Spacer()
                    Text("✦ RANDOM MAGIC")
                        .font(.system(size: 9, weight: .heavy))
                }
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(NoelPalette.cream)
                .padding(17)
                .background(LinearGradient(colors: [
                    Color(red: 0.24, green: 0.18, blue: 0.38),
                    Color(red: 0.12, green: 0.25, blue: 0.28)
                ], startPoint: .leading, endPoint: .trailing),
                    in: RoundedRectangle(cornerRadius: 17))
            }
            .buttonStyle(.plain)
        }
    }

    private var startControls: some View {
        VStack(spacing: 12) {
            Button {
                Task { await startChristmas() }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "sparkles")
                    Text(running ? "RESTART CHRISTMAS ISLAND" : "LAUNCH CHRISTMAS ISLAND")
                }
                .font(.system(size: 14, weight: .heavy, design: .rounded))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 19)
                .foregroundStyle(NoelPalette.background)
                .background(NoelPalette.mint, in: RoundedRectangle(cornerRadius: 18))
            }
            .disabled(busy)

            if running {
                Button("Stop Live Activity") {
                    Task { await stopChristmas() }
                }
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(NoelPalette.muted)
                .disabled(busy)
            }
            Text(status)
                .font(.system(size: 12))
                .foregroundStyle(NoelPalette.cream.opacity(0.8))
                .multilineTextAlignment(.center)
        }
    }

    private var nightstandControls: some View {
        Button {
            showNightstand = true
        } label: {
            HStack(spacing: 13) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(NoelPalette.gold)
                VStack(alignment: .leading, spacing: 5) {
                    Text("WINTER NIGHTSTAND")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .foregroundStyle(NoelPalette.cream)
                    Text("Ambient clock + falling snow while this app stays open")
                        .font(.system(size: 11))
                        .foregroundStyle(NoelPalette.muted)
                }
                Spacer()
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .foregroundStyle(NoelPalette.cream)
            }
            .padding(17)
            .background(.white.opacity(0.075), in: RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }

    private var footer: some View {
        VStack(spacing: 7) {
            Text("❄️  NOEL ISLAND / VERSION 2.0  ❄️")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .tracking(1.5)
            Text("Falling snow animates inside this app. The Dynamic Island uses Apple's system-supported Live Activity scenes and short update transitions. Live Activities may end after about eight hours.")
                .font(.system(size: 11))
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(NoelPalette.muted)
        .frame(maxWidth: .infinity)
    }

    private func sectionTitle(_ title: String, caption: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(caption)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(NoelPalette.mint)
            Text(title)
                .font(.system(size: 13, weight: .heavy, design: .rounded))
                .tracking(1.5)
                .foregroundStyle(.white)
        }
    }

    @MainActor
    private func refreshState() async {
        running = !Activity<ChristmasAttributes>.activities.isEmpty
        status = running ? "Magic is live in your Dynamic Island." : "Ready for the North Pole to launch."
    }

    @MainActor
    private func syncActivity() async {
        guard !Activity<ChristmasAttributes>.activities.isEmpty else {
            status = "Scene selected. Launch the Island to show it!"
            return
        }
        let state = ChristmasAttributes.ContentState(
            theme: theme, mood: mood, scene: scene,
            startedAt: Date(), eventUntil: Date().addingTimeInterval(180))
        for activity in Activity<ChristmasAttributes>.activities {
            await activity.update(ActivityContent(state: state, staleDate: nil))
        }
        status = "\(scene.title) sent to your Island ✨"
    }

    @MainActor
    private func startChristmas() async {
        busy = true
        defer { busy = false }
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            status = "Enable Live Activities in iPhone Settings → Apps → Noel Island."
            return
        }
        for activity in Activity<ChristmasAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        let attributes = ChristmasAttributes(christmasDate: ChristmasTime.nextChristmas())
        let state = ChristmasAttributes.ContentState(
            theme: theme, mood: mood, scene: scene,
            startedAt: Date(), eventUntil: Date().addingTimeInterval(180))
        do {
            _ = try Activity.request(attributes: attributes,
                content: ActivityContent(state: state, staleDate: nil), pushType: nil)
            running = true
            status = "It's LIVE! Long-press the Island for the magic."
        } catch {
            running = false
            status = "Could not launch: \(error.localizedDescription)"
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
        status = "Christmas Island stopped. Start it whenever you like."
    }
}

// Big visual scene: the moon and landscape change instantly when an event is picked.
private struct HolidayHeroView: View {
    let theme: ChristmasTheme
    let scene: NorthPoleScene

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                LinearGradient(colors: sceneColors, startPoint: .topLeading, endPoint: .bottomTrailing)
                Circle()
                    .fill(.white.opacity(0.8))
                    .frame(width: 70, height: 70)
                    .blur(radius: 1)
                    .offset(x: 100, y: -48)
                Circle()
                    .fill(.white.opacity(0.22))
                    .frame(width: 115, height: 115)
                    .blur(radius: 22)
                    .offset(x: 100, y: -48)

                VStack(alignment: .leading, spacing: 11) {
                    HStack {
                        Label("NORTH POLE / LIVE", systemImage: "sparkle")
                        Spacer()
                        Text("✦  02:00 AM")
                    }
                    .font(.system(size: 9, weight: .heavy, design: .rounded))
                    .tracking(1.3)
                    .foregroundStyle(NoelPalette.cream.opacity(0.85))
                    Spacer()
                    Text(scene.icon)
                        .font(.system(size: 39))
                    Text(scene.title)
                        .font(.system(size: 23, weight: .heavy, design: .rounded))
                    Text(scene.caption)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.white.opacity(0.82))
                }
                .foregroundStyle(.white)
                .padding(23)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 240)
            .clipped()

            TimelineView(.periodic(from: .now, by: 60)) { timeline in
                let christmas = ChristmasTime.nextChristmas(from: timeline.date)
                let days = ChristmasTime.days(until: christmas, from: timeline.date)
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline, spacing: 7) {
                        Text("\(days)")
                            .font(.system(size: 51, weight: .black, design: .rounded))
                        Text("DAYS TO CHRISTMAS")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .tracking(1)
                    }
                    .foregroundStyle(NoelPalette.cream)
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.white.opacity(0.17))
                            Capsule()
                                .fill(LinearGradient(colors: [NoelPalette.mint, NoelPalette.gold],
                                    startPoint: .leading, endPoint: .trailing))
                                .frame(width: geometry.size.width * ChristmasTime.progress(to: christmas, from: timeline.date))
                        }
                    }
                    .frame(height: 6)
                    HStack {
                        Text("THE COUNTDOWN IS ON")
                        Spacer()
                        Text(theme.emoji + "  " + theme.title)
                    }
                    .font(.system(size: 9, weight: .heavy))
                    .foregroundStyle(NoelPalette.muted)
                }
                .padding(20)
            }
            .background(NoelPalette.night)
        }
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .overlay(RoundedRectangle(cornerRadius: 26).stroke(.white.opacity(0.12)))
    }

    private var sceneColors: [Color] {
        switch scene {
        case .winterNight: return [Color(red: 0.07, green: 0.18, blue: 0.34), Color(red: 0.12, green: 0.36, blue: 0.37)]
        case .sleighFlyby: return [Color(red: 0.43, green: 0.11, blue: 0.23), Color(red: 0.12, green: 0.21, blue: 0.35)]
        case .giftShower: return [Color(red: 0.43, green: 0.26, blue: 0.12), Color(red: 0.17, green: 0.32, blue: 0.27)]
        case .snowstorm: return [Color(red: 0.16, green: 0.41, blue: 0.53), Color(red: 0.10, green: 0.19, blue: 0.35)]
        case .northernLights: return [Color(red: 0.06, green: 0.39, blue: 0.29), Color(red: 0.20, green: 0.13, blue: 0.45)]
        case .starWish: return [Color(red: 0.28, green: 0.16, blue: 0.47), Color(red: 0.13, green: 0.23, blue: 0.41)]
        }
    }
}

private struct AnimatedSnowView: View {
    let mood: ChristmasMood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private struct Flake {
        let x: CGFloat
        let y: CGFloat
        let size: CGFloat
        let speed: Double
        let drift: Double
    }
    private static let flakes: [Flake] = makeFlakes()

    private static func makeFlakes() -> [Flake] {
        var result: [Flake] = []
        result.reserveCapacity(135)
        for index in 0..<135 {
            let x = CGFloat((index * 137 + 47) % 997) / CGFloat(997)
            let y = CGFloat((index * 263 + 109) % 991) / CGFloat(991)
            let size = CGFloat((index % 4) + 1)
            let speed = Double((index % 5) + 2) * 0.012
            let drift = Double((index % 7) + 3)
            result.append(Flake(x: x, y: y, size: size, speed: speed, drift: drift))
        }
        return result
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 24.0, paused: reduceMotion)) { context in
            Canvas { canvas, bounds in
                let time = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate
                for flake in Self.flakes.prefix(mood.flakeCount) {
                    let sideways = sin(time * 0.6 + Double(flake.y) * 18.0) * flake.drift
                    let x = flake.x * bounds.width + CGFloat(sideways)
                    let progress = (Double(flake.y) + time * flake.speed)
                        .truncatingRemainder(dividingBy: 1.0)
                    let y = CGFloat(progress) * bounds.height
                    let rect = CGRect(x: x, y: y, width: flake.size, height: flake.size)
                    canvas.fill(Path(ellipseIn: rect), with: .color(.white.opacity(mood == .blizzard ? 0.82 : 0.52)))
                }
            }
        }
    }
}

// A foreground-only nightstand-style display for standard iPhone 15 models.
// This does NOT unlock the system Always-On Display or run on the Lock Screen.
private struct NoelNightstandView: View {
    let theme: ChristmasTheme
    let mood: ChristmasMood
    let scene: NorthPoleScene

    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color(red: 0.005, green: 0.014, blue: 0.035)
                .ignoresSafeArea()

            AnimatedSnowView(mood: mood)
                .opacity(0.45)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack(spacing: 20) {
                HStack {
                    Text("NOEL  /  NIGHTSTAND")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(2.2)
                        .foregroundStyle(Color(red: 0.55, green: 0.79, blue: 0.71))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.white.opacity(0.65))
                    }
                    .accessibilityLabel("Close nightstand")
                }
                .padding(.top, 20)

                Spacer()

                Text(theme.emoji)
                    .font(.system(size: 55))
                TimelineView(.periodic(from: .now, by: 1)) { timeline in
                    VStack(spacing: 7) {
                        Text(timeline.date, format: .dateTime.hour().minute())
                            .font(.system(size: 85, weight: .ultraLight, design: .rounded))
                            .monospacedDigit()
                            .minimumScaleFactor(0.7)
                        Text(timeline.date, format: .dateTime.weekday(.wide).month(.wide).day())
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                    .foregroundStyle(Color(red: 0.87, green: 0.96, blue: 0.92))
                }

                TimelineView(.periodic(from: .now, by: 60)) { timeline in
                    let days = ChristmasTime.days(until: ChristmasTime.nextChristmas(from: timeline.date), from: timeline.date)
                    Text("\(days) DAYS TO CHRISTMAS  ❄️")
                        .font(.system(size: 13, weight: .heavy, design: .rounded))
                        .tracking(1.7)
                        .foregroundStyle(Color(red: 0.58, green: 0.88, blue: 0.76))
                }
                Text(scene.caption)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))

                Spacer()
                Text("Display stays awake only while Noel Island is open.\nLock your iPhone normally to turn the screen off.")
                    .font(.system(size: 10))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.36))
                    .padding(.bottom, 14)
            }
            .padding(.horizontal, 28)
        }
        .persistentSystemOverlays(.hidden)
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        .onChange(of: scenePhase) { _, phase in
            UIApplication.shared.isIdleTimerDisabled = (phase == .active)
        }
    }
}
