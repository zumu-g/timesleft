import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            Form {
                if let profile {
                    Section("Your Profile") {
                        DatePicker(
                            "Birth Date",
                            selection: Binding(
                                get: { profile.birthDate },
                                set: { profile.birthDate = $0 }
                            ),
                            in: ...Date(),
                            displayedComponents: .date
                        )

                        Picker("Gender", selection: Binding(
                            get: { profile.gender },
                            set: { profile.gender = $0 }
                        )) {
                            ForEach(Gender.allCases) { g in
                                Text(g.rawValue).tag(g)
                            }
                        }

                        HStack {
                            Text("Your Age")
                            Spacer()
                            Text("\(profile.age)")
                                .font(.system(.body, design: .rounded, weight: .semibold))
                                .foregroundStyle(.accent)
                        }
                    }

                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("2.0")
                                .foregroundStyle(.secondary)
                        }

                        Link(destination: URL(string: "https://waitbutwhy.com/2015/12/the-tail-end.html")!) {
                            HStack {
                                Text("The Tail End by Tim Urban")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } else {
                    Section {
                        Text("No profile found. Please restart the app.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Person.self, UserProfile.self], inMemory: true)
}
