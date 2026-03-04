import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }

            PeopleListView()
                .tabItem {
                    Label("People", systemImage: "person.3.fill")
                }
        }
        .tint(.accentColor)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Person.self, inMemory: true)
}
