import SwiftUI
import SwiftData

struct LifeCalendarView: View {
    @Query private var profiles: [UserProfile]

    private var profile: UserProfile? { profiles.first }

    private var weeksLived: Int {
        guard let profile else { return 0 }
        let days = Calendar.current.dateComponents([.day], from: profile.birthDate, to: Date()).day ?? 0
        return days / 7
    }

    private var totalWeeks: Int {
        guard let profile else { return 4004 }
        let lifeExpectancy = LifeExpectancyData.lifeExpectancy(
            currentAge: profile.age,
            gender: profile.gender
        )
        return Int(lifeExpectancy) * 52
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header stats
                    headerStats
                        .padding(.top, 20)
                        .padding(.bottom, 24)

                    Rectangle().fill(Color.tlDivider).frame(height: 0.5)
                        .padding(.horizontal, 20)

                    // The grid — the whole point
                    WeeksCanvasGrid(
                        totalWeeks: totalWeeks,
                        weeksLived: weeksLived,
                        weeksPerRow: 52
                    )
                    .padding(.horizontal, 8)
                    .padding(.vertical, 24)

                    // Legend
                    legend
                        .padding(.bottom, 32)
                }
            }
            .background(Color.tlBackground.ignoresSafeArea())
            .navigationTitle("Your Life")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var headerStats: some View {
        HStack {
            VStack(spacing: 4) {
                Text("\(weeksLived)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlTextTertiary)
                Text("WEEKS LIVED")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)

            Rectangle()
                .fill(Color.tlDivider)
                .frame(width: 0.5, height: 40)

            VStack(spacing: 4) {
                Text("\(totalWeeks - weeksLived)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlCopper)
                Text("WEEKS LEFT")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)
            .accessibilityElement(children: .combine)
        }
        .padding(.horizontal, 20)
    }

    private var legend: some View {
        HStack(spacing: 24) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.tlPast)
                    .frame(width: 10, height: 10)
                Text("Lived")
                    .font(.tlCaption)
                    .foregroundStyle(Color.tlTextTertiary)
            }
            HStack(spacing: 6) {
                Rectangle()
                    .fill(Color.tlBone)
                    .frame(width: 10, height: 10)
                Text("Remaining")
                    .font(.tlCaption)
                    .foregroundStyle(Color.tlTextTertiary)
            }
        }
    }
}

// MARK: - Canvas Grid

struct WeeksCanvasGrid: View {
    let totalWeeks: Int
    let weeksLived: Int
    let weeksPerRow: Int

    private var totalRows: Int {
        (totalWeeks + weeksPerRow - 1) / weeksPerRow
    }

    var body: some View {
        GeometryReader { geometry in
            let availableWidth = geometry.size.width
            let spacing: CGFloat = 1
            let cellSize = (availableWidth - CGFloat(weeksPerRow - 1) * spacing) / CGFloat(weeksPerRow)
            let effectiveCell = max(cellSize, 1)
            let totalHeight = CGFloat(totalRows) * (effectiveCell + spacing)

            Canvas { context, size in
                let livedColor = Color.tlPast
                let remainingColor = Color.tlBone

                for week in 0..<totalWeeks {
                    let col = week % weeksPerRow
                    let row = week / weeksPerRow
                    let rect = CGRect(
                        x: CGFloat(col) * (effectiveCell + spacing),
                        y: CGFloat(row) * (effectiveCell + spacing),
                        width: effectiveCell,
                        height: effectiveCell
                    )
                    let color = week < weeksLived ? livedColor : remainingColor
                    context.fill(Path(rect), with: .color(color))
                }
            }
            .frame(height: totalHeight)
        }
        .frame(height: CGFloat(totalRows) * 8)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Life calendar")
        .accessibilityValue("\(weeksLived) weeks lived, \(totalWeeks - weeksLived) weeks remaining")
    }
}

#Preview {
    LifeCalendarView()
        .modelContainer(for: [Person.self, UserProfile.self], inMemory: true)
}
