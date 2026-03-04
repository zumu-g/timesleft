import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var birthDate: Date
    var genderRaw: String
    var hasCompletedOnboarding: Bool

    var gender: Gender {
        get { Gender(rawValue: genderRaw) ?? .male }
        set { genderRaw = newValue.rawValue }
    }

    var age: Int {
        Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
    }

    init(
        birthDate: Date,
        gender: Gender = .male,
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = UUID()
        self.birthDate = birthDate
        self.genderRaw = gender.rawValue
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
