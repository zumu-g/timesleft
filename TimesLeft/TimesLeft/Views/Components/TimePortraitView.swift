import SwiftUI
import SwiftData

struct TimePortraitView: View {
    let person: Person
    let stats: TimeStats

    private let columns = 20

    private var visitLabel: String {
        if person.visitsPerYear >= 52 {
            return "Sundays"
        } else if person.visitsPerYear >= 12 {
            return "meetups"
        } else if person.visitsPerYear >= 4 {
            return "get-togethers"
        } else {
            return "visits"
        }
    }

    var body: some View {
        shareableContent
    }

    @ViewBuilder
    var shareableContent: some View {
        VStack(spacing: 24) {
            Spacer()

            // Person name
            Text(person.name)
                .font(.system(size: 18, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))
                .tracking(2)
                .textCase(.uppercase)

            // The grid
            let total = stats.totalExpectedVisits
            let completed = stats.visitsCompleted
            let cellCount = min(total, 400)
            let pastCount = min(completed, cellCount)

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: columns),
                spacing: 3
            ) {
                ForEach(0..<cellCount, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 1.5)
                        .fill(index < pastCount ? Color.white.opacity(0.08) : Color.accentColor)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(.horizontal, 8)

            // The stat line
            VStack(spacing: 8) {
                Text("\(stats.remainingVisits)")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.accentColor)

                Text("\(visitLabel) left with \(person.name).")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            // Watermark
            Text("timesleft.app")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.25))
                .tracking(1)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct ShareableTimePortrait: View {
    let person: Person
    let stats: TimeStats
    @State private var showingShareSheet = false
    @Environment(\.dismiss) private var dismiss

    @State private var shareImage: Image?
    @State private var shareUIImage: UIImage?

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TimePortraitView(person: person, stats: stats)

            HStack(spacing: 16) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Close")

                Button {
                    renderShareImage()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title2)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(12)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Share image")
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .sheet(item: Binding(
            get: { shareUIImage.map { ShareableImage(image: $0) } },
            set: { if $0 == nil { shareUIImage = nil } }
        )) { item in
            ShareSheetView(image: item.image)
        }
    }

    @MainActor
    private func renderShareImage() {
        let renderer = ImageRenderer(content:
            TimePortraitView(person: person, stats: stats)
                .frame(width: 390, height: 690)
        )
        renderer.scale = 3.0
        shareUIImage = renderer.uiImage
    }
}

// MARK: - Share helpers

private struct ShareableImage: Identifiable {
    let id = UUID()
    let image: UIImage
}

private struct ShareSheetView: UIViewControllerRepresentable {
    let image: UIImage

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
