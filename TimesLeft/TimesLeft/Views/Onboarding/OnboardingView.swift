import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: OnboardingPhase = .askAge
    @State private var parentName = ""
    @State private var parentAge = ""
    @State private var parentGender: Gender = .female
    @State private var frequency: VisitFrequency = .fewTimesYear
    @State private var userBirthDate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var userGender: Gender = .male

    // Reveal animation states
    @State private var showNumber = false
    @State private var showContext = false
    @State private var showCTA = false

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
        let raw = Int(parentAge) ?? 65
        return min(max(raw, 1), 120)
    }

    private var isAgeValid: Bool {
        guard let age = Int(parentAge) else { return false }
        return age >= 1 && age <= 120
    }

    private var remainingVisits: Int {
        let yearsRemaining = LifeExpectancyData.yearsRemaining(currentAge: parentAgeInt, gender: parentGender)
        return Int(yearsRemaining * frequency.visitsPerYear)
    }

    var body: some View {
        ZStack {
            Color.tlVoid.ignoresSafeArea()

            switch phase {
            case .askAge:
                askAgeView.transition(.opacity)
            case .askFrequency:
                askFrequencyView.transition(.opacity)
            case .reveal:
                revealView.transition(.opacity)
            case .setupProfile:
                setupProfileView.transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Screen 1: Ask

    private var askAgeView: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("Think of someone\nyou love.")
                .font(.tlDisplayText)
                .foregroundStyle(Color.tlBone)
                .multilineTextAlignment(.center)
                .padding(.bottom, 48)

            VStack(spacing: 16) {
                TextField("Their name", text: $parentName)
                    .font(.system(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.tlBone)
                    .padding(.vertical, 16)
                    .overlay(
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundStyle(Color.tlDivider),
                        alignment: .bottom
                    )

                TextField("Their age", text: $parentAge)
                    .font(.system(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.tlBone)
                    .keyboardType(.numberPad)
                    .padding(.vertical, 16)
                    .overlay(
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundStyle(Color.tlDivider),
                        alignment: .bottom
                    )
                    .onChange(of: parentAge) { _, newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if filtered != newValue || filtered.count > 3 {
                            parentAge = String(filtered.prefix(3))
                        }
                    }

                // Gender — minimal pill selectors
                HStack(spacing: 1) {
                    ForEach(Gender.allCases) { g in
                        Button {
                            parentGender = g
                        } label: {
                            Text(g.rawValue)
                                .font(.system(size: 15, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(parentGender == g ? Color.tlCopper : Color.clear)
                                .foregroundStyle(parentGender == g ? Color.tlBone : Color.tlTextSecondary)
                        }
                        .accessibilityAddTraits(parentGender == g ? .isSelected : [])
                    }
                }
                .background(Color.tlSurface)
                .padding(.top, 8)
            }
            .frame(maxWidth: 340)

            Spacer()

            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    phase = .askFrequency
                }
            } label: {
                Text("Next")
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(parentName.isEmpty || !isAgeValid ? Color.tlSurface : Color.tlCopper)
                    .foregroundStyle(parentName.isEmpty || !isAgeValid ? Color.tlTextSecondary : Color.tlBone)
            }
            .disabled(parentName.isEmpty || !isAgeValid)
            .frame(maxWidth: 340)
            .padding(.bottom, 60)
        }
    }

    // MARK: - Screen 2: Frequency

    private var askFrequencyView: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("How often do you\nsee \(parentName)?")
                .font(.tlDisplayText)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.tlBone)
                .padding(.bottom, 48)

            VStack(spacing: 1) {
                ForEach(VisitFrequency.allCases, id: \.self) { freq in
                    Button {
                        frequency = freq
                    } label: {
                        HStack {
                            Text(freq.rawValue)
                                .font(.system(size: 17, weight: .regular))
                            Spacer()
                            if frequency == freq {
                                Circle()
                                    .fill(Color.tlCopper)
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(frequency == freq ? Color.tlSurface : Color.clear)
                        .foregroundStyle(Color.tlBone)
                    }
                    .accessibilityAddTraits(frequency == freq ? .isSelected : [])
                }
            }
            .frame(maxWidth: 340)

            Spacer()

            HStack(spacing: 1) {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .askAge
                    }
                } label: {
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundStyle(Color.tlTextSecondary)
                }

                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .reveal
                    }
                    triggerReveal()
                } label: {
                    Text("Show me")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.tlCopper)
                        .foregroundStyle(Color.tlBone)
                }
            }
            .frame(maxWidth: 340)
            .padding(.bottom, 60)
        }
    }

    // MARK: - Screen 3: The Reveal — the void speaks

    private var revealView: some View {
        VStack(spacing: 0) {
            Spacer()

            if showNumber {
                Text("\(remainingVisits)")
                    .font(.tlHeroNumber)
                    .foregroundStyle(Color.tlCopper)
                    .minimumScaleFactor(0.5)
                    .accessibilityLabel("\(remainingVisits) visits remaining")
                    .transition(.opacity)
            }

            if showContext {
                VStack(spacing: 8) {
                    Text("visits left with \(parentName).")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(Color.tlTextSecondary)

                    Rectangle()
                        .fill(Color.tlDivider)
                        .frame(width: 40, height: 0.5)
                        .padding(.vertical, 16)

                    Text("This is what's left.")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(Color.tlTextTertiary)
                }
                .transition(.opacity)
                .padding(.top, 16)
            }

            Spacer()

            if showCTA {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .setupProfile
                    }
                } label: {
                    Text("Continue")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.tlCopper)
                        .foregroundStyle(Color.tlBone)
                }
                .frame(maxWidth: 340)
                .padding(.bottom, 60)
                .transition(.opacity)
            }
        }
    }

    private func triggerReveal() {
        if reduceMotion {
            showNumber = true
            showContext = true
            showCTA = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 0.6)) {
                    showNumber = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeOut(duration: 0.8)) {
                    showContext = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    showCTA = true
                }
            }
        }
    }

    // MARK: - Screen 4: Profile Setup

    private var setupProfileView: some View {
        VStack(spacing: 0) {
            Spacer()

            Text("About you")
                .font(.tlDisplayText)
                .foregroundStyle(Color.tlBone)
                .padding(.bottom, 8)

            Text("For accurate calculations")
                .font(.tlSubheadline)
                .foregroundStyle(Color.tlTextSecondary)
                .padding(.bottom, 48)

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("BIRTH DATE")
                        .font(.tlLabel)
                        .foregroundStyle(Color.tlTextTertiary)
                        .tracking(1.5)

                    DatePicker("", selection: $userBirthDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("GENDER")
                        .font(.tlLabel)
                        .foregroundStyle(Color.tlTextTertiary)
                        .tracking(1.5)

                    HStack(spacing: 1) {
                        ForEach(Gender.allCases) { g in
                            Button {
                                userGender = g
                            } label: {
                                Text(g.rawValue)
                                    .font(.system(size: 15, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(userGender == g ? Color.tlCopper : Color.clear)
                                    .foregroundStyle(userGender == g ? Color.tlBone : Color.tlTextSecondary)
                            }
                            .accessibilityAddTraits(userGender == g ? .isSelected : [])
                        }
                    }
                    .background(Color.tlSurface)
                }
            }
            .frame(maxWidth: 340)

            Spacer()

            HStack(spacing: 1) {
                Button {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .reveal
                    }
                } label: {
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .foregroundStyle(Color.tlTextSecondary)
                }

                Button {
                    completeOnboarding()
                } label: {
                    Text("Begin")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.tlCopper)
                        .foregroundStyle(Color.tlBone)
                }
            }
            .frame(maxWidth: 340)
            .padding(.bottom, 60)
        }
    }

    private func completeOnboarding() {
        let profile = UserProfile(
            birthDate: userBirthDate,
            gender: userGender,
            hasCompletedOnboarding: true
        )
        modelContext.insert(profile)

        if !parentName.isEmpty {
            let person = Person(
                name: parentName,
                relationship: .parent,
                gender: parentGender,
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
