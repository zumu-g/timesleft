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
        guard let profile else { return 4004 } // 77 years * 52 weeks
        let lifeExpectancy = LifeExpectancyData.lifeExpectancy(
            currentAge: profile.age,
            gender: profile.gender
        )
        return Int(lifeExpectancy) * 52
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerStats

                    WeeksCanvasGrid(
                        totalWeeks: totalWeeks,
                        weeksLived: weeksLived,
                        weeksPerRow: 52
                    )
                    .padding(.horizontal, 4)

                    legend
                }
                .padding()
            }
            .navigationTitle("Your Life")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    private var headerStats: some View {
        HStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("\(weeksLived)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.secondary)
                Text("weeks lived")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .accessibilityElement(children: .combine)

            VStack(spacing: 4) {
                Text("\(totalWeeks - weeksLived)")
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(.accent)
                Text("weeks left")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .accessibilityElement(children: .combine)
        }
        .padding(.vertical, 8)
    }

    private var legend: some View {
        HStack(spacing: 24) {
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 12, height: 12)
                Text("Lived")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.accentColor)
                    .frame(width: 12, height: 12)
                Text("Remaining")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Canvas-based grid for performance (4,000+ cells)

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
                let livedColor = Color.gray.opacity(0.15)
                let remainingColor = Color.accentColor

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
