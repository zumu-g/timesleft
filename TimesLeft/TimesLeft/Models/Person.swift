import Foundation
import SwiftData

enum RelationshipType: String, Codable, CaseIterable, Identifiable {
    case parent = "Parent"
    case child = "Child"
    case sibling = "Sibling"
    case grandparent = "Grandparent"
    case friend = "Friend"
    case partner = "Partner"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .parent: return "figure.and.child.holdinghands"
        case .child: return "figure.child"
        case .sibling: return "person.2"
        case .grandparent: return "figure.2.and.child.holdinghands"
        case .friend: return "person.2.wave.2"
        case .partner: return "heart.fill"
        case .other: return "person"
        }
    }
}

enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"

    var id: String { rawValue }
}

@Model
final class Person {
    var id: UUID
    var name: String
    var relationshipRaw: String
    var genderRaw: String
    var birthDate: Date
    var visitsPerYear: Double
    var daysPerVisit: Double
    var livesNearby: Bool
    var notes: String
    var createdAt: Date

    var relationship: RelationshipType {
        get { RelationshipType(rawValue: relationshipRaw) ?? .other }
        set { relationshipRaw = newValue.rawValue }
    }

    var gender: Gender {
        get { Gender(rawValue: genderRaw) ?? .male }
        set { genderRaw = newValue.rawValue }
    }

    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    init(
        name: String,
        relationship: RelationshipType,
        gender: Gender,
        birthDate: Date,
        visitsPerYear: Double = 4,
        daysPerVisit: Double = 1,
        livesNearby: Bool = false,
        notes: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.relationshipRaw = relationship.rawValue
        self.genderRaw = gender.rawValue
        self.birthDate = birthDate
        self.visitsPerYear = visitsPerYear
        self.daysPerVisit = daysPerVisit
        self.livesNearby = livesNearby
        self.notes = notes
        self.createdAt = Date()
    }
}
