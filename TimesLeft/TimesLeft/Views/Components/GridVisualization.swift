import SwiftUI

// MARK: - Grid Visualization — "The Void"
//
// Squares on black. Past = barely visible. Future = bone white.
// The visual of what's gone vs what's left.

struct GridVisualization: View {
    let total: Int
    let completed: Int
    let columns: Int

    private var rows: Int {
        (total + columns - 1) / columns
    }

    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = 2
            let availableWidth = geometry.size.width - (CGFloat(columns - 1) * spacing)
            let availableHeight = geometry.size.height - (CGFloat(rows - 1) * spacing)
            let cellWidth = availableWidth / CGFloat(columns)
            let cellHeight = min(cellWidth, availableHeight / CGFloat(rows))

            LazyVGrid(
                columns: Array(repeating: GridItem(.fixed(cellWidth), spacing: spacing), count: columns),
                spacing: spacing
            ) {
                ForEach(0..<total, id: \.self) { index in
                    Rectangle()
                        .fill(index < completed ? Color.tlPast : Color.tlBone)
                        .frame(width: cellWidth, height: cellHeight)
                }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Visit grid")
        .accessibilityValue("\(completed) of \(total) visits completed, \(total - completed) remaining")
    }
}

struct AnimatedGridVisualization: View {
    let total: Int
    let completed: Int
    let columns: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animatedCompleted = 0

    var body: some View {
        GridVisualization(total: total, completed: animatedCompleted, columns: columns)
            .onAppear {
                if reduceMotion {
                    animatedCompleted = completed
                } else {
                    withAnimation(.easeOut(duration: 1.5)) {
                        animatedCompleted = completed
                    }
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        GridVisualization(total: 90, completed: 81, columns: 10)
            .frame(height: 200)

        GridVisualization(total: 150, completed: 50, columns: 15)
            .frame(height: 200)
    }
    .padding()
    .background(Color.tlBackground)
}
