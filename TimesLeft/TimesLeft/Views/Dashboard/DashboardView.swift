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
            .navigationTitle("TimesLeft")
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView()
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "hourglass")
                    .font(.system(size: 64))
                    .foregroundStyle(.accent)

                Text("Make Time Count")
                    .font(.system(.title, design: .rounded, weight: .bold))

                Text("Inspired by Tim Urban's \"The Tail End\", this app helps you visualize and appreciate the limited time you have with the people you love.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button("Add Your First Person") {
                showingAddPerson = true
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Spacer()
        }
        .padding()
    }

    private var moveCloserInsight: (Person, Int)? {
        // Find the person who isn't nearby where moving closer would have the biggest impact
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

    private var dashboardContent: some View {
        VStack(spacing: 20) {
            summarySection
            urgentSection
            moveCloserSection
            peopleOverviewSection
        }
        .padding()
    }

    private var summarySection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatsCardView(
                    title: "People",
                    value: "\(people.count)",
                    icon: "person.3.fill",
                    color: .accentColor
                )
                StatsCardView(
                    title: "Total Visits",
                    value: "\(totalRemainingVisits)",
                    icon: "calendar.badge.clock",
                    color: .accentColor.opacity(0.7)
                )
            }
        }
    }

    @ViewBuilder
    private var urgentSection: some View {
        if let (urgent, stats) = mostUrgent {
            VStack(alignment: .leading, spacing: 12) {
                Label("Prioritize", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(.accent)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(urgent.name)
                            .font(.system(.title3, design: .rounded, weight: .semibold))

                        Text("\(Int(stats.percentageUsed))% of time spent")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    NavigationLink(destination: PersonDetailView(person: urgent)) {
                        Text("View")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .buttonStyle(.bordered)
                }

                ProgressView(value: stats.percentageUsed / 100)
                    .tint(.accent)
            }
            .padding()
            .background(Color.accentColor.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    @ViewBuilder
    private var moveCloserSection: some View {
        if let (person, delta) = moveCloserInsight {
            VStack(alignment: .leading, spacing: 8) {
                Label("What if?", systemImage: "mappin.and.ellipse")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(.accent)

                Text("Moving closer to \(person.name) would give you **\(delta) more visits**.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.accentColor.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var peopleOverviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your People")
                    .font(.headline)
                Spacer()
                Button(action: { showingAddPerson = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }

            ForEach(peopleWithStats, id: \.0.id) { person, stats in
                NavigationLink(destination: PersonDetailView(person: person)) {
                    personCard(person, stats: stats)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func personCard(_ person: Person, stats: TimeStats) -> some View {
        HStack(spacing: 12) {
            Image(systemName: person.relationship.icon)
                .font(.title2)
                .foregroundStyle(.accent)
                .frame(width: 44, height: 44)
                .background(Color.accentColor.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text("\(stats.remainingVisits) visits left")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            ProgressRing(progress: stats.percentageUsed / 100, size: 44, lineWidth: 4)
        }
        .cardStyle(cornerRadius: 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(person.name), \(person.relationship.rawValue), \(stats.remainingVisits) visits left, \(Int(stats.percentageUsed))% spent")
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Person.self, inMemory: true)
}
