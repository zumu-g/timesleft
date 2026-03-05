import SwiftUI
import SwiftData

struct PersonDetailView: View {
    @Bindable var person: Person
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @State private var showingSharePortrait = false

    private var yourAge: Int { profiles.first?.age ?? 30 }

    private var stats: TimeStats {
        TimeCalculator.calculate(for: person, yourAge: yourAge)
    }

    private var specialOccasions: [String: Int] {
        TimeCalculator.specialOccasionsRemaining(for: person, yourAge: yourAge)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                mainStatsSection
                if let insight = TimeCalculator.tailEndInsight(for: person, yourAge: yourAge) {
                    insightSection(insight)
                }
                gridSection
                occasionsSection
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingSharePortrait = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .fullScreenCover(isPresented: $showingSharePortrait) {
            ShareableTimePortrait(person: person, stats: stats)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: person.relationship.icon)
                .font(.system(size: 48))
                .foregroundStyle(.accent)

            Text(person.relationship.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(person.age) years old")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .cardStyle()
        .accessibilityElement(children: .combine)
    }

    private var mainStatsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatsCardView(
                    title: "Visits Left",
                    value: "\(stats.remainingVisits)",
                    icon: "calendar",
                    color: .accentColor
                )
                StatsCardView(
                    title: "Days Together",
                    value: "\(stats.remainingDays)",
                    icon: "sun.max.fill",
                    color: .accentColor.opacity(0.7)
                )
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Time Together")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(stats.percentageUsed))% spent")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                ProgressRing(progress: stats.percentageUsed / 100, size: 120)
                    .padding(.vertical, 8)

                Text(stats.motivationalMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .cardStyle()
        }
    }

    private var gridSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Time Together")
                .font(.headline)

            GridVisualization(
                total: stats.totalExpectedVisits,
                completed: stats.visitsCompleted,
                columns: 20
            )
            .frame(height: 200)

            HStack {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 12, height: 12)
                    Text("Past")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 12, height: 12)
                    Text("Future")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .cardStyle()
    }

    private var occasionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Special Occasions Left")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Array(specialOccasions.keys.sorted()), id: \.self) { occasion in
                    HStack {
                        Text(occasion)
                            .font(.subheadline)
                        Spacer()
                        Text("~\(specialOccasions[occasion] ?? 0)")
                            .font(.system(.title3, design: .rounded, weight: .semibold))
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .cardStyle()
    }

    private func insightSection(_ insight: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("The Tail End", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(.accent)

            Text(insight)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        PersonDetailView(
            person: Person(
                name: "Mom",
                relationship: .parent,
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .year, value: -65, to: Date())!,
                visitsPerYear: 5,
                daysPerVisit: 3
            )
        )
    }
    .modelContainer(for: Person.self, inMemory: true)
}
