import SwiftUI
import SwiftData

struct PeopleListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Person.name) private var people: [Person]
    @Query private var profiles: [UserProfile]
    @State private var showingAddPerson = false
    @State private var personToDelete: Person?
    @State private var showDeleteConfirmation = false

    private var yourAge: Int { profiles.first?.age ?? 30 }

    var body: some View {
        NavigationStack {
            Group {
                if people.isEmpty {
                    emptyStateView
                } else {
                    peopleList
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddPerson = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView()
            }
        }
    }

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No People Yet", systemImage: "person.3")
        } description: {
            Text("Add the people you care about to see how much time you have left together.")
        } actions: {
            Button("Add Person") {
                showingAddPerson = true
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var peopleList: some View {
        List {
            ForEach(people) { person in
                NavigationLink(destination: PersonDetailView(person: person)) {
                    PersonRowView(person: person, yourAge: yourAge)
                }
            }
            .onDelete { offsets in
                if let index = offsets.first {
                    personToDelete = people[index]
                    showDeleteConfirmation = true
                }
            }
        }
        .alert("Delete Person", isPresented: $showDeleteConfirmation, presenting: personToDelete) { person in
            Button("Delete", role: .destructive) {
                modelContext.delete(person)
                personToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                personToDelete = nil
            }
        } message: { person in
            Text("Are you sure you want to remove \(person.name)? This can't be undone.")
        }
    }
}

struct PersonRowView: View {
    let person: Person
    var yourAge: Int = 30

    private var stats: TimeStats {
        TimeCalculator.calculate(for: person, yourAge: yourAge)
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: person.relationship.icon)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(person.name)
                    .font(.headline)

                Text("\(person.relationship.rawValue) • \(person.age) years old")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("\(stats.remainingVisits)")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)

                Text("visits left")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PeopleListView()
        .modelContainer(for: Person.self, inMemory: true)
}
