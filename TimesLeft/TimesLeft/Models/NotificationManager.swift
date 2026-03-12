import Foundation
import UserNotifications
import SwiftData

@MainActor
final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    func scheduleDailyReminder(people: [Person], yourAge: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: (0..<7).map { "daily-fact-\($0)" })

        guard !people.isEmpty else { return }

        let facts = generateFacts(people: people, yourAge: yourAge)
        guard !facts.isEmpty else { return }

        // Schedule 7 days of notifications so they rotate even if app isn't opened
        for day in 0..<7 {
            let fact = facts[day % facts.count]

            let content = UNMutableNotificationContent()
            content.title = fact.title
            content.body = fact.body
            content.sound = .default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            dateComponents.minute = 0

            // For day 0, use today's trigger (repeating daily would just be one)
            // For days 1-6, offset the date
            let triggerDate = Calendar.current.date(byAdding: .day, value: day, to: Date()) ?? Date()
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)

            var components = DateComponents()
            components.year = triggerComponents.year
            components.month = triggerComponents.month
            components.day = triggerComponents.day
            components.hour = 9
            components.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(
                identifier: "daily-fact-\(day)",
                content: content,
                trigger: trigger
            )

            center.add(request)
        }
    }

    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Fact Generation

    private struct Fact {
        let title: String
        let body: String
    }

    private func generateFacts(people: [Person], yourAge: Int) -> [Fact] {
        var facts: [Fact] = []

        for person in people {
            let stats = TimeCalculator.calculate(for: person, yourAge: yourAge)
            let occasions = TimeCalculator.specialOccasionsRemaining(for: person, yourAge: yourAge)

            facts.append(Fact(
                title: "\(person.name)",
                body: "You have ~\(stats.remainingVisits) visits left. Make today count."
            ))

            if let christmases = occasions["Christmases"], christmases > 0 {
                facts.append(Fact(
                    title: "Christmases with \(person.name)",
                    body: "About \(christmases) left. That number is smaller than you think."
                ))
            }

            if stats.percentageUsed >= 75 {
                facts.append(Fact(
                    title: "Time with \(person.name)",
                    body: "\(Int(stats.percentageUsed))% of your time together is already behind you."
                ))
            }

            if stats.remainingDays > 0 {
                facts.append(Fact(
                    title: "\(person.name)",
                    body: "~\(stats.remainingDays) days left together. What will you do with them?"
                ))
            }

            if let summers = occasions["Summers"], summers > 0 && summers < 30 {
                facts.append(Fact(
                    title: "Summers with \(person.name)",
                    body: "Only about \(summers) left. Plan the next one."
                ))
            }
        }

        // Shuffle so each week feels different
        return facts.shuffled()
    }
}
