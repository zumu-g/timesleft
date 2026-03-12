import SwiftUI
import SwiftData

// MARK: - Time Portrait — "The Void"
//
// A stark, shareable image. Number on black. Nothing else.
// This is what gets screenshotted and shared.

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
        ZStack {
            Color.tlVoid.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Name — small, tracked, above the number
                Text(person.name.uppercased())
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(3)
                    .padding(.bottom, 24)

                // The grid — the visual anchor
                let total = stats.totalExpectedVisits
                let completed = stats.visitsCompleted
                let cellCount = min(total, 400)
                let pastCount = min(completed, cellCount)

                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: columns),
                    spacing: 2
                ) {
                    ForEach(0..<cellCount, id: \.self) { index in
                        Rectangle()
                            .fill(index < pastCount ? Color.tlPast : Color.tlCopper)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)

                // The number
                Text("\(stats.remainingVisits)")
                    .font(.tlDisplayNumber)
                    .foregroundStyle(Color.tlCopper)
                    .padding(.bottom, 4)

                Text("\(visitLabel) left.")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.tlTextSecondary)

                Spacer()

                // Watermark
                Text("TIMESLEFT")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(Color.tlTextTertiary.opacity(0.5))
                    .tracking(3)
                    .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.tlTextSecondary)
                        .padding(14)
                }
                .accessibilityLabel("Close")

                Button {
                    renderShareImage()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.tlTextSecondary)
                        .padding(14)
                }
                .accessibilityLabel("Share image")
            }
            .padding(.top, 4)
            .padding(.trailing, 4)
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
