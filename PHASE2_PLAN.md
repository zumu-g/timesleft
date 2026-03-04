# TimesLeft App - Phase 2 Implementation Plan

## Overview
Expand the app with features directly inspired by Tim Urban's "The Tail End" article: your own life calendar, life activities tracking, notifications, widgets, and an onboarding experience.

## Current Status: NOT STARTED

---

## What's Already Built (Phase 1)
- [x] Person model with SwiftData persistence
- [x] Life expectancy calculations with 10x nearby multiplier
- [x] People list, add, and detail views
- [x] Grid visualization and progress rings
- [x] Dashboard with stats and priority person
- [x] Special occasions remaining (Christmases, birthdays, etc.)
- [x] Tail End insight for parents/grandparents

---

## New Features to Implement

### 1. User Profile & Settings
**Why:** The app currently hardcodes `yourAge: Int = 30`. Need user's actual age for accurate calculations.

**Files:**
- `Models/UserProfile.swift` - SwiftData model for user info
- `Views/Settings/SettingsView.swift` - Settings screen
- `Views/Settings/ProfileSetupView.swift` - Initial profile setup

**Data Model:**
```swift
@Model
class UserProfile {
    var birthDate: Date
    var gender: Gender
    var notificationsEnabled: Bool
    var notificationTime: Date  // When to send daily reminder
    var hasCompletedOnboarding: Bool
}
```

**Status:** [ ] Not Started

---

### 2. Your Life Calendar (The Iconic Visualization)
**Why:** Tim Urban visualizes his entire life in weeks. This is the most impactful visual from the article.

**Files:**
- `Views/LifeCalendar/LifeCalendarView.swift` - Full-screen life in weeks
- `Views/Components/WeeksGridView.swift` - Reusable weeks grid component

**Features:**
- Show ~4,000 weeks (assuming 77-year lifespan) in a grid
- Filled squares = weeks lived, empty = weeks remaining
- Tap a row to see that year's details
- Color coding by life phase (childhood, education, career, retirement)

**Status:** [ ] Not Started

---

### 3. Life Activities Tracker
**Why:** Tim Urban calculates remaining books, ocean swims, Super Bowls, pizza meals, etc.

**Files:**
- `Models/LifeActivity.swift` - SwiftData model
- `Views/Activities/ActivitiesListView.swift` - List of tracked activities
- `Views/Activities/AddActivityView.swift` - Add new activity
- `Views/Activities/ActivityDetailView.swift` - Activity stats

**Data Model:**
```swift
@Model
class LifeActivity {
    var id: UUID
    var name: String
    var icon: String
    var frequencyPerYear: Double  // How often you do it
    var category: ActivityCategory  // food, travel, entertainment, etc.
    var notes: String
}

enum ActivityCategory: String, Codable, CaseIterable {
    case food, travel, entertainment, sports, reading, social, other
}
```

**Preset Activities:**
- Books to read (~300 remaining at 5/year)
- Ocean/lake swims (~60 remaining)
- Holidays/Christmases (~50 remaining)
- Concerts to attend
- Trips abroad
- Favorite meals (pizza, dumplings, etc.)

**Status:** [ ] Not Started

---

### 4. Push Notifications
**Why:** Daily reminders with rotating insights about different people/activities.

**Files:**
- `Services/NotificationService.swift` - Handle scheduling & permissions

**Notification Types:**
- "You have ~47 Christmases left with Mom. Make this one count."
- "Call Dad this week? You have ~85 visits left."
- "You've read 2,000 books. About 300 more to go."
- Weekly summary: "This week: 3 people you haven't seen in 6+ months"

**Status:** [ ] Not Started

---

### 5. Home Screen Widgets (WidgetKit)
**Why:** Keep stats visible without opening app.

**Files:**
- `Widgets/TimesLeftWidget/TimesLeftWidget.swift` - Widget extension
- `Widgets/TimesLeftWidget/WidgetViews.swift` - Widget UI

**Widget Sizes:**
- **Small:** Single person with visits remaining + progress ring
- **Medium:** Top 3 people with their stats
- **Large:** Mini life calendar + top people

**Status:** [ ] Not Started

---

### 6. Visit/Interaction Logging
**Why:** Track actual visits to make calculations more accurate over time.

**Files:**
- `Models/Visit.swift` - SwiftData model for logged visits
- `Views/People/LogVisitView.swift` - Quick visit logging sheet

**Data Model:**
```swift
@Model
class Visit {
    var id: UUID
    var personId: UUID
    var date: Date
    var duration: Double  // days
    var notes: String
}
```

**Features:**
- Quick "I saw them today" button on person detail
- Visit history on person detail view
- Refine visitsPerYear based on actual data

**Status:** [ ] Not Started

---

### 7. Onboarding Flow
**Why:** Explain the concept with emotional impact before asking for data.

**Files:**
- `Views/Onboarding/OnboardingView.swift` - Multi-page onboarding
- `Views/Onboarding/OnboardingPageView.swift` - Individual pages

**Pages:**
1. "Your life in weeks" - Show the iconic grid visual
2. "The Tail End" - Explain the 93% parent time concept
3. "Make it count" - How the app helps
4. "Set up your profile" - Age, gender for accurate calculations
5. "Add your first person" - Quick add flow

**Status:** [ ] Not Started

---

### 8. Location Impact Feature
**Why:** The article emphasizes that living nearby gives 10x more time. Make this more prominent.

**Enhancement to existing views:**
- Add "What if you moved closer?" toggle on PersonDetailView
- Show side-by-side comparison of visits with/without nearby status
- Dashboard insight: "Moving closer to Mom would give you 400 more visits"

**Status:** [ ] Not Started

---

## Updated Tab Structure

```
TabView {
    DashboardView      // Overview + insights
    PeopleListView     // Your people
    ActivitiesView     // Life activities (NEW)
    LifeCalendarView   // Your life in weeks (NEW)
    SettingsView       // Profile + notifications (NEW)
}
```

---

## Implementation Order

### Phase 2A: Foundation
- [ ] 1. UserProfile model + SettingsView
- [ ] 2. Update TimeCalculator to use actual user age
- [ ] 3. Onboarding flow

### Phase 2B: Life Calendar
- [ ] 4. WeeksGridView component
- [ ] 5. LifeCalendarView with your life visualization

### Phase 2C: Activities
- [ ] 6. LifeActivity model
- [ ] 7. ActivitiesListView, AddActivityView, ActivityDetailView
- [ ] 8. Preset activities with smart defaults

### Phase 2D: Notifications & Widgets
- [ ] 9. NotificationService with daily reminders
- [ ] 10. WidgetKit extension with 3 widget sizes

### Phase 2E: Visit Logging & Polish
- [ ] 11. Visit model and LogVisitView
- [ ] 12. Location impact "what if" feature
- [ ] 13. Animations and UI polish

---

## Files to Create

### New Files (17 total)
```
Models/
  UserProfile.swift
  LifeActivity.swift
  Visit.swift

Views/
  Settings/
    SettingsView.swift
    ProfileSetupView.swift
  LifeCalendar/
    LifeCalendarView.swift
  Activities/
    ActivitiesListView.swift
    AddActivityView.swift
    ActivityDetailView.swift
  Onboarding/
    OnboardingView.swift
    OnboardingPageView.swift
  People/
    LogVisitView.swift
  Components/
    WeeksGridView.swift

Services/
  NotificationService.swift

Widgets/
  TimesLeftWidget/
    TimesLeftWidget.swift
    WidgetViews.swift
```

### Files to Modify
- `App/ContentView.swift` - Add new tabs, check onboarding status
- `App/TimesLeftApp.swift` - Add UserProfile to schema, widget configuration
- `Models/TimeCalculator.swift` - Use actual user age from profile
- `Views/People/PersonDetailView.swift` - Add visit logging, location impact

---

## Verification Checklist

- [ ] Build and run in Xcode Simulator
- [ ] Complete onboarding flow, verify profile saves
- [ ] Add a person, verify calculations use your actual age
- [ ] View life calendar, verify weeks calculation is accurate
- [ ] Add a life activity, verify remaining count
- [ ] Enable notifications, verify they schedule correctly
- [ ] Add widget to home screen, verify data displays
- [ ] Log a visit, verify it appears in history
- [ ] Test "move closer" toggle, verify 10x calculation

---

## Notes

_Add implementation notes here as work progresses._
