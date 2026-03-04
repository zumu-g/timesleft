import SwiftUI
import SwiftData

struct AddPersonView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var relationship: RelationshipType = .parent
    @State private var gender: Gender = .female
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -60, to: Date()) ?? Date()
    @State private var visitsPerYear: Double = 4
    @State private var daysPerVisit: Double = 2
    @State private var livesNearby = false
    @State private var notes = ""

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Info") {
                    TextField("Name", text: $name)

                    Picker("Relationship", selection: $relationship) {
                        ForEach(RelationshipType.allCases) { type in
                            Label(type.rawValue, systemImage: type.icon)
                                .tag(type)
                        }
                    }

                    Picker("Gender", selection: $gender) {
                        ForEach(Gender.allCases) { g in
                            Text(g.rawValue).tag(g)
                        }
                    }

                    DatePicker(
                        "Birth Date",
                        selection: $birthDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                }

                Section("How Often Do You See Them?") {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Visits per year")
                            Spacer()
                            Text("\(Int(visitsPerYear))")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $visitsPerYear, in: 1...52, step: 1)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Text("Days per visit")
                            Spacer()
                            Text("\(Int(daysPerVisit))")
                                .foregroundStyle(.secondary)
                        }
                        Slider(value: $daysPerVisit, in: 1...14, step: 1)
                    }

                    Toggle("Lives nearby", isOn: $livesNearby)
                }

                Section("Notes (Optional)") {
                    TextField("Any notes about this person...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }

                if isValid {
                    Section {
                        previewStats
                    } header: {
                        Text("Preview")
                    }
                }
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePerson()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var previewStats: some View {
        let tempPerson = Person(
            name: name,
            relationship: relationship,
            gender: gender,
            birthDate: birthDate,
            visitsPerYear: visitsPerYear,
            daysPerVisit: daysPerVisit,
            livesNearby: livesNearby
        )
        let stats = TimeCalculator.calculate(for: tempPerson)

        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("\(stats.remainingVisits)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("visits remaining")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(stats.remainingDays)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("days together")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ProgressView(value: stats.percentageUsed / 100) {
                Text("\(Int(stats.percentageUsed))% of time already spent")
                    .font(.caption)
            }
            .tint(stats.percentageUsed > 75 ? .orange : .accentColor)
        }
        .padding(.vertical, 8)
    }

    private func savePerson() {
        let person = Person(
            name: name.trimmingCharacters(in: .whitespaces),
            relationship: relationship,
            gender: gender,
            birthDate: birthDate,
            visitsPerYear: visitsPerYear,
            daysPerVisit: daysPerVisit,
            livesNearby: livesNearby,
            notes: notes
        )
        modelContext.insert(person)
        dismiss()
    }
}

#Preview {
    AddPersonView()
        .modelContainer(for: Person.self, inMemory: true)
}
