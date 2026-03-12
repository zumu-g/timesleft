import SwiftUI

// MARK: - Shapes — "The Void"
//
// Clean geometric shapes. No wobble. No grain. No paper.
// The geometry is honest.

// MARK: - Kept for API compatibility

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}

// MARK: - Clean Circle Path (supports .trim)

struct HandDrawnCirclePath: Shape {
    var wobble: CGFloat = 0
    var seed: Int = 0

    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

struct HandDrawnCircle: Shape {
    var wobble: CGFloat = 0
    var seed: Int = 0

    func path(in rect: CGRect) -> Path {
        Path(ellipseIn: rect)
    }
}

// MARK: - Clean Rounded Rectangle

struct HandDrawnRoundedRect: Shape {
    var cornerRadius: CGFloat = 0
    var wobble: CGFloat = 0
    var seed: Int = 0

    func path(in rect: CGRect) -> Path {
        Path(roundedRect: rect, cornerRadius: cornerRadius)
    }
}

// MARK: - Minimal Divider (replaces WobblyUnderline)

struct WobblyUnderline: Shape {
    var amplitude: CGFloat = 0
    var frequency: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

struct WobblyDivider: View {
    var body: some View {
        VoidDivider()
    }
}

// MARK: - Grain Overlay (now a no-op — the void needs no texture)

struct GrainOverlay: View {
    var opacity: Double = 0

    var body: some View {
        Color.clear
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

// MARK: - Paper Background (now void)

struct PaperBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.tlBackground.ignoresSafeArea())
    }
}

extension View {
    func paperBackground() -> some View {
        modifier(PaperBackground())
    }
}
