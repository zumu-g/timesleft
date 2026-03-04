import SwiftUI
import SwiftData

@main
struct TimesLeftApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
