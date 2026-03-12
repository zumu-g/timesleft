import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Person.name) private var people: [Person]
    @Query private var profiles: [UserProfile]
    @State private var showingAddPerson = false

    private var yourAge: Int { profiles.first?.age ?? 30 }

    private var peopleWithStats: [(Person, TimeStats)] {
        people.map { ($0, TimeCalculator.calculate(for: $0, yourAge: yourAge)) }
    }

    private var totalRemainingVisits: Int {
        peopleWithStats.reduce(0) { $0 + $1.1.remainingVisits }
    }

    /// The person with the least time remaining (highest % spent)
    private var mostUrgent: (Person, TimeStats)? {
        peopleWithStats.max { $0.1.percentageRemaining > $1.1.percentageRemaining }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if people.isEmpty {
                    emptyStateView
                } else {
                    dashboardContent
                }
            }
            .background(Color.tlBackground.ignoresSafeArea())
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddPerson = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.tlBone)
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView()
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 120)

            Text("TimesLeft")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(3)
                .textCase(.uppercase)
                .padding(.bottom, 48)

            Text("Who matters\nmost to you?")
                .font(.tlDisplayText)
                .foregroundStyle(Color.tlBone)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)

            Text("See how many visits you have left\nwith the people you love.")
                .font(.tlSubheadline)
                .foregroundStyle(Color.tlTextSecondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 48)

            Button {
                showingAddPerson = true
            } label: {
                Text("Add someone")
                    .font(.system(size: 17, weight: .medium))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.tlCopper)
                    .foregroundStyle(Color.tlBone)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Dashboard Content

    private var dashboardContent: some View {
        VStack(spacing: 0) {
            // Hero section — one number, full attention
            heroSection
                .padding(.top, 20)
                .padding(.bottom, 32)

            Rectangle().fill(Color.tlDivider).frame(height: 0.5)

            // Stats row
            statsRow
                .padding(.vertical, 24)

            Rectangle().fill(Color.tlDivider).frame(height: 0.5)

            // Insight (if available)
            if let (person, delta) = moveCloserInsight {
                insightRow(person: person, delta: delta)
                    .padding(.vertical, 24)
                Rectangle().fill(Color.tlDivider).frame(height: 0.5)
            }

            // People list
            peopleSection
                .padding(.top, 24)
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Hero

    private var heroSection: some View {
        VStack(spacing: 12) {
            if let (urgent, stats) = mostUrgent {
                Text(urgent.name.uppercased())
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
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Stats

    private var statsRow: some View {
        HStack {
            VStack(spacing: 4) {
                Text("\(people.count)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlBone)
                Text("PEOPLE")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.tlDivider)
                .frame(width: 0.5, height: 40)

            VStack(spacing: 4) {
                Text("\(totalRemainingVisits)")
                    .font(.tlStatLarge)
                    .foregroundStyle(Color.tlBone)
                Text("TOTAL VISITS")
                    .font(.tlLabel)
                    .foregroundStyle(Color.tlTextTertiary)
                    .tracking(1.5)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Insight

    private var moveCloserInsight: (Person, Int)? {
        var bestPerson: Person?
        var bestDelta = 0

        for (person, stats) in peopleWithStats where !person.livesNearby {
            let nearbyVisits = Int(LifeExpectancyData.yearsRemaining(
                currentAge: person.age, gender: person.gender
            ) * person.visitsPerYear * 10)
            let delta = nearbyVisits - stats.remainingVisits
            if delta > bestDelta {
                bestDelta = delta
                bestPerson = person
            }
        }

        if let person = bestPerson, bestDelta > 0 {
            return (person, bestDelta)
        }
        return nil
    }

    private func insightRow(person: Person, delta: Int) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("WHAT IF")
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(1.5)

            Text("Moving closer to \(person.name) could mean **\(delta) more visits**.")
                .font(.tlBody)
                .foregroundStyle(Color.tlTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - People List

    private var peopleSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(peopleWithStats.enumerated()), id: \.1.0.id) { index, pair in
                let (person, stats) = pair

                NavigationLink(destination: PersonDetailView(person: person)) {
                    personRow(person, stats: stats)
                }
                .buttonStyle(.plain)

                if index < peopleWithStats.count - 1 {
                    Rectangle().fill(Color.tlDivider).frame(height: 0.5)
                        .padding(.leading, 56)
                }
            }
        }
    }

    private func personRow(_ person: Person, stats: TimeStats) -> some View {
        HStack(spacing: 16) {
            // Minimal icon
            Text(person.relationship.icon == "figure.and.child.holdinghands" ? "P" :
                    String(person.relationship.rawValue.prefix(1)))
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.tlTextSecondary)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .stroke(Color.tlDivider, lineWidth: 0.5)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(person.name)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.tlBone)

                Text("\(stats.remainingVisits) visits left")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.tlTextSecondary)
            }

            Spacer()

            Text("\(Int(stats.percentageUsed))%")
                .font(.system(size: 22, weight: .light, design: .serif))
                .foregroundStyle(Color.tlTextTertiary)
        }
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(person.name), \(person.relationship.rawValue), \(stats.remainingVisits) visits left, \(Int(stats.percentageUsed))% spent")
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Person.self, inMemory: true)
}
