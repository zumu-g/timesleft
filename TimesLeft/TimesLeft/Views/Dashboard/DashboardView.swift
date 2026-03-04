import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Person.name) private var people: [Person]
    @State private var showingAddPerson = false

    private var totalRemainingVisits: Int {
        people.reduce(0) { $0 + TimeCalculator.calculate(for: $1).remainingVisits }
    }

    private var mostUrgent: Person? {
        people.max { a, b in
            TimeCalculator.calculate(for: a).percentageRemaining >
            TimeCalculator.calculate(for: b).percentageRemaining
        }
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
                    .font(.title)
                    .fontWeight(.bold)

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

    private var dashboardContent: some View {
        VStack(spacing: 20) {
            summarySection
            urgentSection
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
                    color: .blue
                )
                StatsCardView(
                    title: "Total Visits",
                    value: "\(totalRemainingVisits)",
                    icon: "calendar.badge.clock",
                    color: .green
                )
            }
        }
    }

    @ViewBuilder
    private var urgentSection: some View {
        if let urgent = mostUrgent {
            let stats = TimeCalculator.calculate(for: urgent)

            VStack(alignment: .leading, spacing: 12) {
                Label("Prioritize", systemImage: "exclamationmark.triangle.fill")
                    .font(.headline)
                    .foregroundStyle(.orange)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(urgent.name)
                            .font(.title3)
                            .fontWeight(.semibold)

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
                    .tint(.orange)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
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

            ForEach(people) { person in
                NavigationLink(destination: PersonDetailView(person: person)) {
                    personCard(person)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func personCard(_ person: Person) -> some View {
        let stats = TimeCalculator.calculate(for: person)

        return HStack(spacing: 12) {
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
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: Person.self, inMemory: true)
}
