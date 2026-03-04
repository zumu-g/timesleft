import Foundation

struct TimeStats {
    let yearsRemaining: Double
    let remainingVisits: Int
    let remainingDays: Int
    let percentageUsed: Double
    let percentageRemaining: Double
    let totalExpectedVisits: Int
    let visitsCompleted: Int

    var formattedYearsRemaining: String {
        if yearsRemaining < 1 {
            return "Less than a year"
        } else if yearsRemaining < 2 {
            return "About 1 year"
        } else {
            return "About \(Int(yearsRemaining)) years"
        }
    }

    var formattedPercentageUsed: String {
        return "\(Int(percentageUsed))%"
    }

    var motivationalMessage: String {
        if percentageUsed >= 90 {
            return "Treasure every moment"
        } else if percentageUsed >= 75 {
            return "Make each visit count"
        } else if percentageUsed >= 50 {
            return "You're past the halfway mark"
        } else {
            return "You still have time"
        }
    }
}

struct TimeCalculator {

    static func calculate(for person: Person, yourAge: Int = 30) -> TimeStats {
        // TODO: Phase 2A - Remove default once all call sites pass actual user age
        let personAge = person.age
        let yearsRemaining = LifeExpectancyData.yearsRemaining(
            currentAge: personAge,
            gender: person.gender
        )

        let remainingVisits: Int
        let remainingDays: Int

        if person.livesNearby {
            remainingVisits = Int(yearsRemaining * person.visitsPerYear * 10)
            remainingDays = Int(Double(remainingVisits) * person.daysPerVisit)
        } else {
            remainingVisits = Int(yearsRemaining * person.visitsPerYear)
            remainingDays = Int(Double(remainingVisits) * person.daysPerVisit)
        }

        let (percentageUsed, totalVisits, visitsCompleted) = calculatePercentageUsed(
            for: person,
            yourAge: yourAge
        )

        return TimeStats(
            yearsRemaining: yearsRemaining,
            remainingVisits: remainingVisits,
            remainingDays: remainingDays,
            percentageUsed: percentageUsed,
            percentageRemaining: 100 - percentageUsed,
            totalExpectedVisits: totalVisits,
            visitsCompleted: visitsCompleted
        )
    }

    static func calculatePercentageUsed(for person: Person, yourAge: Int) -> (Double, Int, Int) {
        let personAge = person.age

        let relationshipStartAge: Int
        switch person.relationship {
        case .parent, .sibling:
            relationshipStartAge = 0
        case .grandparent:
            relationshipStartAge = 0
        case .child:
            relationshipStartAge = max(0, yourAge - personAge)
        case .partner:
            relationshipStartAge = max(18, yourAge - 10)
        case .friend:
            relationshipStartAge = max(5, yourAge - 15)
        case .other:
            relationshipStartAge = max(0, yourAge - 5)
        }

        let yearsKnown = yourAge - relationshipStartAge
        let lifeExpectancy = LifeExpectancyData.lifeExpectancy(
            currentAge: personAge,
            gender: person.gender
        )
        let personRemainingYears = lifeExpectancy - Double(personAge)
        let totalRelationshipYears = Double(yearsKnown) + personRemainingYears

        let childhoodMultiplier: Double
        if person.relationship == .parent || person.relationship == .grandparent {
            let childhoodYears = min(18, yearsKnown)
            let adultYears = max(0, yearsKnown - 18)
            childhoodMultiplier = Double(childhoodYears) * 365 + Double(adultYears) * person.visitsPerYear * person.daysPerVisit
        } else {
            childhoodMultiplier = Double(yearsKnown) * person.visitsPerYear * person.daysPerVisit
        }

        let futureDays = personRemainingYears * person.visitsPerYear * person.daysPerVisit * (person.livesNearby ? 10 : 1)
        let totalDays = childhoodMultiplier + futureDays

        let percentageUsed = totalDays > 0 ? (childhoodMultiplier / totalDays) * 100 : 0

        let visitsCompleted = Int(Double(yearsKnown) * person.visitsPerYear)
        let totalVisits = visitsCompleted + Int(personRemainingYears * person.visitsPerYear * (person.livesNearby ? 10 : 1))

        return (min(100, max(0, percentageUsed)), totalVisits, visitsCompleted)
    }

    static func specialOccasionsRemaining(for person: Person, yourAge: Int = 30) -> [String: Int] {
        let personYearsRemaining = LifeExpectancyData.yearsRemaining(
            currentAge: person.age,
            gender: person.gender
        )
        let yourYearsRemaining = LifeExpectancyData.yearsRemaining(
            currentAge: yourAge,
            gender: .male
        )
        // Use the shorter of the two lifespans
        let yearsOfOccasions = Int(min(personYearsRemaining, yourYearsRemaining))

        // How many you'll actually share depends on visit frequency
        let visitsPerYear = person.visitsPerYear * (person.livesNearby ? 10 : 1)
        let sharedHolidays: Int
        if visitsPerYear >= 4 {
            sharedHolidays = yearsOfOccasions
        } else if visitsPerYear >= 1 {
            sharedHolidays = Int(Double(yearsOfOccasions) * min(visitsPerYear / 4.0, 1.0))
        } else {
            sharedHolidays = Int(Double(yearsOfOccasions) * visitsPerYear)
        }

        return [
            "Christmases": sharedHolidays,
            "Birthdays": yearsOfOccasions,
            "Summers": sharedHolidays,
            "Phone calls": Int(Double(yearsOfOccasions) * min(visitsPerYear * 2, 52))
        ]
    }

    static func tailEndInsight(for person: Person, yourAge: Int) -> String? {
        let stats = calculate(for: person, yourAge: yourAge)

        switch person.relationship {
        case .parent, .grandparent:
            if stats.percentageUsed >= 90 {
                return "You've already spent \(Int(stats.percentageUsed))% of your time with \(person.name). Most of your time together happened during childhood."
            } else if stats.percentageUsed >= 75 {
                return "About \(Int(stats.percentageUsed))% of your time with \(person.name) is already behind you. Each visit matters more than you think."
            }
        case .partner:
            if stats.percentageUsed >= 50 {
                return "You're past the halfway point with \(person.name). \(stats.remainingVisits) visits may sound like a lot — but count them."
            }
        case .friend:
            if stats.percentageUsed >= 60 {
                return "If you don't live nearby, most friendships run on a handful of visits. You have ~\(stats.remainingVisits) left with \(person.name)."
            }
        case .sibling:
            if stats.percentageUsed >= 70 {
                return "After childhood, sibling time drops dramatically. You have ~\(stats.remainingVisits) visits left with \(person.name)."
            }
        default:
            if stats.percentageUsed >= 75 {
                return "About \(Int(stats.percentageUsed))% of your time with \(person.name) is behind you."
            }
        }

        return nil
    }
}
