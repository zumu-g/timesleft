import SwiftUI

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
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index < completed ? Color.gray.opacity(0.15) : Color.accentColor)
                        .frame(width: cellWidth, height: cellHeight)
                }
            }
        }
    }
}

struct AnimatedGridVisualization: View {
    let total: Int
    let completed: Int
    let columns: Int

    @State private var animatedCompleted = 0

    var body: some View {
        GridVisualization(total: total, completed: animatedCompleted, columns: columns)
            .onAppear {
                withAnimation(.easeOut(duration: 1.5)) {
                    animatedCompleted = completed
                }
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("90 total, 81 completed (90%)")
            .font(.headline)

        GridVisualization(total: 90, completed: 81, columns: 10)
            .frame(height: 200)

        Text("150 total, 50 completed (33%)")
            .font(.headline)

        GridVisualization(total: 150, completed: 50, columns: 15)
            .frame(height: 200)
    }
    .padding()
}
