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
            VStack(spacing: 0) {
                // Hero — the number
                heroSection
                    .padding(.top, 20)
                    .padding(.bottom, 32)

                Rectangle().fill(Color.tlDivider).frame(height: 0.5)

                // Stats
                statsSection
                    .padding(.vertical, 24)

                Rectangle().fill(Color.tlDivider).frame(height: 0.5)

                // Progress
                progressSection
                    .padding(.vertical, 24)

                Rectangle().fill(Color.tlDivider).frame(height: 0.5)

                // Insight
                if let insight = TimeCalculator.tailEndInsight(for: person, yourAge: yourAge) {
                    insightSection(insight)
                        .padding(.vertical, 24)
                    Rectangle().fill(Color.tlDivider).frame(height: 0.5)
                }

                // Grid
                gridSection
                    .padding(.vertical, 24)

                Rectangle().fill(Color.tlDivider).frame(height: 0.5)

                // Occasions
                occasionsSection
                    .padding(.vertical, 24)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.tlBackground.ignoresSafeArea())
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingSharePortrait = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(Color.tlBone)
                }
            }
        }
        .fullScreenCover(isPresented: $showingSharePortrait) {
            ShareableTimePortrait(person: person, stats: stats)
        }
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 12) {
            Text(person.relationship.rawValue.uppercased())
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(2)

            Text("\(stats.remainingVisits)")
                .font(.tlFeatureNumber)
                .foregroundStyle(Color.tlCopper)

            Text("visits left")
                .font(.tlSubheadline)
                .foregroundStyle(Color.tlTextSecondary)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Stats

    private var statsSection: some View {
        HStack {
            VStack(spacing: 4) {
                Text("\(stats.remainingVisits)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlBone)
                Text("VISITS LEFT")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.tlDivider)
                .frame(width: 0.5, height: 40)

            VStack(spacing: 4) {
                Text("\(stats.remainingDays)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlBone)
                Text("DAYS LEFT")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Progress

    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("\(Int(stats.percentageUsed))% spent")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.tlTextSecondary)

                Spacer()

                Text("\(Int(stats.percentageRemaining))% left")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.tlBone)
            }

            // Minimal progress bar — no ring
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.tlDivider)
                        .frame(height: 2)

                    Rectangle()
                        .fill(Color.tlCopper)
                        .frame(width: geo.size.width * (stats.percentageUsed / 100), height: 2)
                }
            }
            .frame(height: 2)

            Text(stats.motivationalMessage)
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.tlTextTertiary)
        }
    }

    // MARK: - Insight

    private func insightSection(_ insight: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("THE TAIL END")
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(1.5)

            Text(insight)
                .font(.tlBody)
                .foregroundStyle(Color.tlTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Grid

    private var gridSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("YOUR TIME")
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(1.5)

            GridVisualization(
                total: stats.totalExpectedVisits,
                completed: stats.visitsCompleted,
                columns: 20
            )
            .frame(height: 200)

            HStack {
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.tlPast)
                        .frame(width: 10, height: 10)
                    Text("Past")
                        .font(.tlCaption)
                        .foregroundStyle(Color.tlTextTertiary)
                }
                Spacer()
                HStack(spacing: 6) {
                    Rectangle()
                        .fill(Color.tlBone)
                        .frame(width: 10, height: 10)
                    Text("Future")
                        .font(.tlCaption)
                        .foregroundStyle(Color.tlTextTertiary)
                }
            }
        }
    }

    // MARK: - Occasions

    private var occasionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("OCCASIONS LEFT")
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(1.5)

            ForEach(Array(specialOccasions.keys.sorted()), id: \.self) { occasion in
                HStack {
                    Text(occasion)
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.tlTextSecondary)
                    Spacer()
                    Text("~\(specialOccasions[occasion] ?? 0)")
                        .font(.system(size: 22, weight: .light, design: .serif))
                        .foregroundStyle(Color.tlBone)
                }
                .padding(.vertical, 4)
            }
        }
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
