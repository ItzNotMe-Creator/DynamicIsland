import SwiftUI

/// Lightweight vector scene shared by the app, Lock Screen and expanded Dynamic Island.
/// WidgetKit renders a snapshot; the app layers actual animated snow over this artwork.
struct NoelSceneArt: View {
    let scene: NorthPoleScene
    let mood: ChristmasMood

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: skyColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(Color.white.opacity(0.22))
                    .frame(width: 105, height: 105)
                    .blur(radius: 26)
                    .position(
                        x: geometry.size.width * 0.81,
                        y: geometry.size.height * 0.26
                    )

                Circle()
                    .fill(Color(red: 0.95, green: 0.98, blue: 1))
                    .frame(width: 28, height: 28)
                    .shadow(color: .white.opacity(0.45), radius: 12)
                    .position(
                        x: geometry.size.width * 0.81,
                        y: geometry.size.height * 0.26
                    )

                Canvas { context, size in
                    // Deterministic star field: no random flashing or animation claims.
                    var stars = Path()
                    let starCount = mood == .blizzard ? 12 : 29
                    for index in 0..<starCount {
                        let xFraction = CGFloat((index * 139 + 29) % 997) / 997
                        let yFraction = CGFloat((index * 181 + 43) % 991) / 991
                        let diameter = CGFloat(index % 3 + 1)
                        let rect = CGRect(
                            x: xFraction * size.width,
                            y: yFraction * size.height * 0.69,
                            width: diameter,
                            height: diameter
                        )
                        stars.addEllipse(in: rect)
                    }
                    context.fill(stars, with: .color(.white.opacity(0.64)))

                    // Layered mountain silhouettes and a gentle snowy horizon.
                    var distant = Path()
                    distant.move(to: CGPoint(x: 0, y: size.height * 0.71))
                    distant.addLine(to: CGPoint(x: size.width * 0.16, y: size.height * 0.49))
                    distant.addLine(to: CGPoint(x: size.width * 0.37, y: size.height * 0.76))
                    distant.addLine(to: CGPoint(x: size.width * 0.56, y: size.height * 0.55))
                    distant.addLine(to: CGPoint(x: size.width * 0.79, y: size.height * 0.76))
                    distant.addLine(to: CGPoint(x: size.width, y: size.height * 0.51))
                    distant.addLine(to: CGPoint(x: size.width, y: size.height))
                    distant.addLine(to: CGPoint(x: 0, y: size.height))
                    distant.closeSubpath()
                    context.fill(distant, with: .color(Color(red: 0.07, green: 0.20, blue: 0.30).opacity(0.75)))

                    var foreground = Path()
                    foreground.move(to: CGPoint(x: 0, y: size.height * 0.86))
                    foreground.addQuadCurve(
                        to: CGPoint(x: size.width, y: size.height * 0.79),
                        control: CGPoint(x: size.width * 0.52, y: size.height * 0.60)
                    )
                    foreground.addLine(to: CGPoint(x: size.width, y: size.height))
                    foreground.addLine(to: CGPoint(x: 0, y: size.height))
                    foreground.closeSubpath()
                    context.fill(foreground, with: .color(Color(red: 0.13, green: 0.32, blue: 0.35).opacity(0.93)))

                    // Pine silhouettes make the scene feel handcrafted.
                    for index in 0..<8 {
                        let fraction = CGFloat(index) / 7
                        let x = fraction * size.width
                        let treeHeight = size.height * (0.16 + CGFloat(index % 3) * 0.035)
                        let bottom = size.height * (0.94 + CGFloat(index % 2) * 0.05)
                        let halfWidth = treeHeight * 0.30
                        var pine = Path()
                        pine.move(to: CGPoint(x: x, y: bottom - treeHeight))
                        pine.addLine(to: CGPoint(x: x - halfWidth, y: bottom))
                        pine.addLine(to: CGPoint(x: x + halfWidth, y: bottom))
                        pine.closeSubpath()
                        context.fill(pine, with: .color(Color(red: 0.025, green: 0.11, blue: 0.16)))
                    }
                }
            }
        }
        .clipped()
        .accessibilityHidden(true)
    }

    private var skyColors: [Color] {
        switch scene {
        case .winterNight:
            return [Color(red: 0.04, green: 0.11, blue: 0.27),
                    Color(red: 0.10, green: 0.34, blue: 0.42)]
        case .sleighFlyby:
            return [Color(red: 0.31, green: 0.07, blue: 0.19),
                    Color(red: 0.10, green: 0.19, blue: 0.34)]
        case .giftShower:
            return [Color(red: 0.35, green: 0.20, blue: 0.08),
                    Color(red: 0.12, green: 0.35, blue: 0.25)]
        case .snowstorm:
            return [Color(red: 0.15, green: 0.28, blue: 0.41),
                    Color(red: 0.22, green: 0.47, blue: 0.53)]
        case .northernLights:
            return [Color(red: 0.05, green: 0.36, blue: 0.28),
                    Color(red: 0.19, green: 0.11, blue: 0.38)]
        case .starWish:
            return [Color(red: 0.22, green: 0.12, blue: 0.42),
                    Color(red: 0.10, green: 0.27, blue: 0.40)]
        }
    }
}
