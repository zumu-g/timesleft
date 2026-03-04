import Foundation
import SwiftData

@MainActor
class PersistenceService {
    static let shared = PersistenceService()

    let container: ModelContainer

    private init() {
        let schema = Schema([Person.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    var context: ModelContext {
        container.mainContext
    }

    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func addPerson(_ person: Person) {
        context.insert(person)
        save()
    }

    func deletePerson(_ person: Person) {
        context.delete(person)
        save()
    }

    func fetchPeople() -> [Person] {
        let descriptor = FetchDescriptor<Person>(
            sortBy: [SortDescriptor(\.name)]
        )
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Failed to fetch people: \(error)")
            return []
        }
    }
}
