import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \Person.name) private var people: [Person]

    private var hasCompletedOnboarding: Bool {
        profiles.first?.hasCompletedOnboarding ?? false
    }

    var body: some View {
        Group {
            if hasCompletedOnboarding {
                mainTabView
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut(duration: 0.4), value: hasCompletedOnboarding)
        .preferredColorScheme(.dark)
    }

    private var mainTabView: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "square.grid.2x2")
                }

            PeopleListView()
                .tabItem {
                    Label("People", systemImage: "person.2")
                }

            LifeCalendarView()
                .tabItem {
                    Label("Life", systemImage: "circle.grid.3x3")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .tint(Color.tlCopper)
        .onAppear {
            // Force dark tab bar appearance
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = UIColor(Color.tlVoid)
            UITabBar.appearance().standardAppearance = tabBarAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

            // Navigation bar
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = UIColor(Color.tlVoid)
            navAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.tlBone)]
            navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.tlBone)]
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance

            if let profile = profiles.first, profile.dailyRemindersEnabled {
                NotificationManager.shared.scheduleDailyReminder(
                    people: people,
                    yourAge: profile.age
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Person.self, UserProfile.self], inMemory: true)
}
