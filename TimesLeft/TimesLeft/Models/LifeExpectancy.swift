import Foundation

struct LifeExpectancyData {
    static let maleExpectancy: [Int: Double] = [
        0: 76.1, 5: 71.5, 10: 66.5, 15: 61.6, 20: 56.8,
        25: 52.1, 30: 47.4, 35: 42.7, 40: 38.0, 45: 33.5,
        50: 29.1, 55: 24.9, 60: 21.0, 65: 17.4, 70: 14.1,
        75: 11.2, 80: 8.6, 85: 6.5, 90: 4.9, 95: 3.7, 100: 2.8
    ]

    static let femaleExpectancy: [Int: Double] = [
        0: 81.1, 5: 76.4, 10: 71.4, 15: 66.5, 20: 61.6,
        25: 56.7, 30: 51.8, 35: 47.0, 40: 42.2, 45: 37.4,
        50: 32.8, 55: 28.3, 60: 24.0, 65: 19.9, 70: 16.1,
        75: 12.6, 80: 9.5, 85: 7.0, 90: 5.1, 95: 3.8, 100: 2.9
    ]

    static func yearsRemaining(currentAge: Int, gender: Gender) -> Double {
        let table = gender == .male ? maleExpectancy : femaleExpectancy

        let ages = table.keys.sorted()
        var lowerAge = ages.first!
        var upperAge = ages.last!

        for age in ages {
            if age <= currentAge {
                lowerAge = age
            }
            if age >= currentAge {
                upperAge = age
                break
            }
        }

        if lowerAge == upperAge {
            return table[lowerAge]!
        }

        let lowerValue = table[lowerAge]!
        let upperValue = table[upperAge]!
        let ratio = Double(currentAge - lowerAge) / Double(upperAge - lowerAge)

        return lowerValue - (lowerValue - upperValue) * ratio
    }

    static func lifeExpectancy(currentAge: Int, gender: Gender) -> Double {
        return Double(currentAge) + yearsRemaining(currentAge: currentAge, gender: gender)
    }
}
