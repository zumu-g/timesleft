import SwiftUI
import SwiftData

struct PersonDetailView: View {
    @Bindable var person: Person
    @Environment(\.modelContext) private var modelContext

    private var stats: TimeStats {
        TimeCalculator.calculate(for: person)
    }

    private var specialOccasions: [String: Int] {
        TimeCalculator.specialOccasionsRemaining(for: person)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                mainStatsSection
                gridSection
                occasionsSection
                if let insight = TimeCalculator.tailEndInsight(for: person, yourAge: 30) {
                    insightSection(insight)
                }
            }
            .padding()
        }
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.large)
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
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private var mainStatsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatsCardView(
                    title: "Visits Left",
                    value: "\(stats.remainingVisits)",
                    icon: "calendar",
                    color: .blue
                )
                StatsCardView(
                    title: "Days Together",
                    value: "\(stats.remainingDays)",
                    icon: "sun.max.fill",
                    color: .orange
                )
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Time Together")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(stats.percentageUsed))% spent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ProgressRing(progress: stats.percentageUsed / 100, size: 120)
                    .padding(.vertical, 8)

                Text(stats.motivationalMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
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
                        .fill(Color.gray.opacity(0.3))
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
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
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
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }

    private func insightSection(_ insight: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("The Tail End", systemImage: "lightbulb.fill")
                .font(.headline)
                .foregroundStyle(.orange)

            Text(insight)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.1))
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
