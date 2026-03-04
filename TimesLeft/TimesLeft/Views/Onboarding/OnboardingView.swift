import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var phase: OnboardingPhase = .askAge
    @State private var parentName = ""
    @State private var parentAge = ""
    @State private var frequency: VisitFrequency = .fewTimesYear
    @State private var userBirthDate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var userGender: Gender = .male

    // Reveal animation states
    @State private var showNumber = false
    @State private var showGrid = false
    @State private var showMessage = false
    @State private var animatedFill = 0

    enum OnboardingPhase {
        case askAge
        case askFrequency
        case reveal
        case setupProfile
    }

    enum VisitFrequency: String, CaseIterable {
        case weekly = "Weekly"
        case monthly = "Monthly"
        case fewTimesYear = "A few times a year"
        case onceYear = "Once a year"
        case rarely = "Rarely"

        var visitsPerYear: Double {
            switch self {
            case .weekly: return 52
            case .monthly: return 12
            case .fewTimesYear: return 4
            case .onceYear: return 1
            case .rarely: return 0.5
            }
        }

        var daysPerVisit: Double {
            switch self {
            case .weekly: return 1
            case .monthly: return 1
            case .fewTimesYear: return 2
            case .onceYear: return 3
            case .rarely: return 2
            }
        }
    }

    private var parentAgeInt: Int {
        Int(parentAge) ?? 65
    }

    private var remainingVisits: Int {
        let yearsRemaining = LifeExpectancyData.yearsRemaining(currentAge: parentAgeInt, gender: .female)
        return Int(yearsRemaining * frequency.visitsPerYear)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch phase {
            case .askAge:
                askAgeView
                    .transition(.opacity)
            case .askFrequency:
                askFrequencyView
                    .transition(.opacity)
            case .reveal:
                revealView
                    .transition(.opacity)
            case .setupProfile:
                setupProfileView
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Screen 1: Ask about their parent

    private var askAgeView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("Think of someone\nyou love.")
                .font(.system(.title, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            VStack(spacing: 16) {
                TextField("Their name", text: $parentName)
                    .font(.system(.title2, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                TextField("Their age", text: $parentAge)
                    .font(.system(.title2, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 40)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    phase = .askFrequency
                }
            } label: {
                Text("Next")
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(parentName.isEmpty || parentAge.isEmpty)
            .opacity(parentName.isEmpty || parentAge.isEmpty ? 0.4 : 1)
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Screen 2: Ask frequency

    private var askFrequencyView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("How often do you\nsee \(parentName)?")
                .font(.system(.title, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            VStack(spacing: 12) {
                ForEach(VisitFrequency.allCases, id: \.self) { freq in
                    Button {
                        frequency = freq
                    } label: {
                        Text(freq.rawValue)
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(frequency == freq ? Color.accentColor : Color.white.opacity(0.1))
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.horizontal, 40)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.5)) {
                    phase = .reveal
                }
                // Trigger reveal animations after transition
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeOut(duration: 0.8)) {
                        showNumber = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut(duration: 1.0)) {
                        showGrid = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                    withAnimation(.easeOut(duration: 0.8)) {
                        showMessage = true
                    }
                }
            } label: {
                Text("Show me")
                    .font(.system(.headline, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    // MARK: - Screen 3: The Reveal

    private var revealView: some View {
        VStack(spacing: 24) {
            Spacer()

            if showNumber {
                Text("\(remainingVisits)")
                    .font(.system(size: 96, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.accentColor)

                Text("visits left with \(parentName).")
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(.white.opacity(0.8))
            }

            if showGrid {
                revealGrid
                    .padding(.horizontal, 20)
            }

            if showMessage {
                Text("This is what's left.\nMake it count.")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
            }

            Spacer()

            if showMessage {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        phase = .setupProfile
                    }
                } label: {
                    Text("Set up my profile")
                        .font(.system(.headline, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .transition(.opacity)
            }
        }
    }

    private var revealGrid: some View {
        let totalVisits = remainingVisits + estimatedPastVisits
        let columns = 20
        let cellCount = min(totalVisits, 400)
        let pastCount = min(estimatedPastVisits, cellCount)

        return LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: columns),
            spacing: 3
        ) {
            ForEach(0..<cellCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(index < pastCount ? Color.gray.opacity(0.15) : Color.accentColor)
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }

    private var estimatedPastVisits: Int {
        let userAge = Calendar.current.dateComponents([.year], from: userBirthDate, to: Date()).year ?? 30
        let childhoodYears = min(18, userAge)
        let adultYears = max(0, userAge - 18)
        return childhoodYears * 365 / 7 + Int(Double(adultYears) * frequency.visitsPerYear)
    }

    // MARK: - Screen 4: Profile Setup

    private var setupProfileView: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("About you")
                .font(.system(.title, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text("For accurate calculations")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.6))

            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your birth date")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))

                    DatePicker("", selection: $userBirthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .colorScheme(.dark)
                }

                HStack(spacing: 16) {
                    ForEach(Gender.allCases) { g in
                        Button {
                            userGender = g
                        } label: {
                            Text(g.rawValue)
                                .font(.system(.body, design: .rounded, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(userGender == g ? Color.accentColor : Color.white.opacity(0.1))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
            .padding(.horizontal, 40)

            Spacer()

            Button {
                completeOnboarding()
            } label: {
                Text("Get Started")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }

    private func completeOnboarding() {
        // Create user profile
        let profile = UserProfile(
            birthDate: userBirthDate,
            gender: userGender,
            hasCompletedOnboarding: true
        )
        modelContext.insert(profile)

        // Create their first person from onboarding
        if !parentName.isEmpty {
            let person = Person(
                name: parentName,
                relationship: .parent,
                gender: .female,
                birthDate: Calendar.current.date(byAdding: .year, value: -parentAgeInt, to: Date()) ?? Date(),
                visitsPerYear: frequency.visitsPerYear,
                daysPerVisit: frequency.daysPerVisit
            )
            modelContext.insert(person)
        }
    }
}

#Preview {
    OnboardingView()
        .modelContainer(for: [Person.self, UserProfile.self], inMemory: true)
}
