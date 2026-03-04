# TimesLeft

A SwiftUI app inspired by Tim Urban's "The Tail End" article that helps you visualize and make the most of the limited time you have with the people you love.

## Concept

Tim Urban's viral Wait But Why article shows how we've already used up the majority of our in-person time with parents by age 18. This app makes that concept tangible and actionable.

## Features

### Phase 1 (Complete)
- **Person Management**: Add people with relationship types, visit frequency, and location
- **Life Expectancy Calculations**: Uses actuarial tables with 10x nearby multiplier
- **Dashboard**: Overview of all people with priority insights
- **Visual Progress**: Grid visualization and progress rings showing time spent vs remaining
- **Special Occasions**: Track remaining Christmases, birthdays, etc.
- **Tail End Insights**: Motivational messages for parents/grandparents

### Phase 2 (Planned)
- User profile with actual birth date for accurate calculations
- Your Life Calendar (life in weeks visualization)
- Life Activities Tracker (books to read, trips remaining, etc.)
- Push notifications with rotating insights
- Home screen widgets
- Visit logging to refine calculations
- Onboarding flow

## Project Structure

```
TimesLeft/
├── App/
│   ├── TimesLeftApp.swift      # App entry point, SwiftData setup
│   └── ContentView.swift       # Root TabView
├── Models/
│   ├── Person.swift            # Person model with relationships
│   ├── TimeCalculator.swift    # Time calculations and stats
│   └── LifeExpectancy.swift    # Actuarial life expectancy tables
├── Views/
│   ├── Dashboard/
│   │   ├── DashboardView.swift
│   │   └── StatsCardView.swift
│   ├── People/
│   │   ├── PeopleListView.swift
│   │   ├── AddPersonView.swift
│   │   └── PersonDetailView.swift
│   └── Components/
│       ├── ProgressRing.swift
│       └── GridVisualization.swift
└── Services/
    └── PersistenceService.swift
```

## Technology Stack

- **SwiftUI** for UI
- **SwiftData** for persistence
- **iOS 17+** minimum deployment target

## Getting Started

1. Open `TimesLeft.xcodeproj` in Xcode
2. Build and run on iOS Simulator or device
3. Add your first person to start tracking

## Inspiration

- [The Tail End](https://waitbutwhy.com/2015/12/the-tail-end.html) by Tim Urban
- [Your Life in Weeks](https://waitbutwhy.com/2014/05/life-weeks.html) by Tim Urban
