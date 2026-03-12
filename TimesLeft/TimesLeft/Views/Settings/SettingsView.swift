import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \Person.name) private var people: [Person]
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
                                .font(.system(size: 17, weight: .regular, design: .serif))
                                .foregroundStyle(Color.tlBone)
                        }
                    }

                    Section {
                        Toggle("Daily Reminder", isOn: Binding(
                            get: { profile.dailyRemindersEnabled },
                            set: { newValue in
                                Task {
                                    if newValue {
                                        let granted = await NotificationManager.shared.requestPermission()
                                        profile.dailyRemindersEnabled = granted
                                        if granted {
                                            NotificationManager.shared.scheduleDailyReminder(
                                                people: people,
                                                yourAge: profile.age
                                            )
                                        }
                                    } else {
                                        profile.dailyRemindersEnabled = false
                                        NotificationManager.shared.cancelAll()
                                    }
                                }
                            }
                        ))
                    } header: {
                        Text("Notifications")
                    } footer: {
                        Text("A daily reminder at 9 AM.")
                    }

                    Section("About") {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("3.0")
                                .foregroundStyle(.secondary)
                        }

                        Link(destination: URL(string: "https://waitbutwhy.com/2015/12/the-tail-end.html") ?? URL(string: "https://waitbutwhy.com")!) {
                            HStack {
                                Text("The Tail End — Tim Urban")
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption)
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
            .scrollContentBackground(.hidden)
            .background(Color.tlBackground.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: [Person.self, UserProfile.self], inMemory: true)
}
