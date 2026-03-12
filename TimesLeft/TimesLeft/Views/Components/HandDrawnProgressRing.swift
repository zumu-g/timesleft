import SwiftUI

// MARK: - Progress Ring — "The Void"
//
// A clean circle. Thin stroke. The number inside is what matters.

struct HandDrawnProgressRing: View {
    let progress: Double
    var size: CGFloat = 100
    var lineWidth: CGFloat = 2
    var seed: Int = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var normalizedProgress: Double {
        min(max(progress, 0), 1)
    }

    var body: some View {
        ZStack {
            // Track — barely visible
            Circle()
                .stroke(Color.tlDivider, lineWidth: lineWidth)

            // Progress arc
            Circle()
                .trim(from: 0, to: normalizedProgress)
                .stroke(Color.tlBone, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: normalizedProgress)

            // Center number
            VStack(spacing: 0) {
                Text("\(Int(normalizedProgress * 100))")
                    .font(.tlRingPercentage(ringSize: size))
                    .foregroundStyle(Color.tlBone)

                if size > 60 {
                    Text("spent")
                        .font(.tlRingLabel(ringSize: size))
                        .foregroundStyle(Color.tlTextSecondary)
                        .textCase(.uppercase)
                        .tracking(1)
                }
            }
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Time spent")
        .accessibilityValue("\(Int(normalizedProgress * 100)) percent")
    }
}
