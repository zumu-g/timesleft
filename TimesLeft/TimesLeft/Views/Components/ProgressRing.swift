import SwiftUI

struct ProgressRing: View {
    let progress: Double
    var size: CGFloat = 100
    var lineWidth: CGFloat = 8

    private var normalizedProgress: Double {
        min(max(progress, 0), 1)
    }

    private var progressColor: Color {
        if normalizedProgress >= 0.9 {
            return .red
        } else if normalizedProgress >= 0.75 {
            return .orange
        } else if normalizedProgress >= 0.5 {
            return .yellow
        } else {
            return .green
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: normalizedProgress)
                .stroke(
                    progressColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 0.5), value: normalizedProgress)

            VStack(spacing: 0) {
                Text("\(Int(normalizedProgress * 100))%")
                    .font(.system(size: size * 0.22, weight: .bold, design: .rounded))

                if size > 60 {
                    Text("spent")
                        .font(.system(size: size * 0.12))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(width: size, height: size)
    }
}

struct ProgressRingWithLabel: View {
    let progress: Double
    let label: String
    var size: CGFloat = 100

    var body: some View {
        VStack(spacing: 8) {
            ProgressRing(progress: progress, size: size)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        HStack(spacing: 24) {
            ProgressRing(progress: 0.25)
            ProgressRing(progress: 0.50)
            ProgressRing(progress: 0.75)
            ProgressRing(progress: 0.93)
        }

        HStack(spacing: 24) {
            ProgressRingWithLabel(progress: 0.93, label: "Mom", size: 80)
            ProgressRingWithLabel(progress: 0.45, label: "Best Friend", size: 80)
            ProgressRingWithLabel(progress: 0.20, label: "Partner", size: 80)
        }

        ProgressRing(progress: 0.87, size: 150, lineWidth: 12)
    }
    .padding()
}
