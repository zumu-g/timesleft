# TimesLeft - Session Restart Prompt

Copy and paste this to continue where we left off:

---

## Prompt:

We're continuing work on the TimesLeft iOS app. Here's where we are:

**Last session (2026-03-17):** We completed a radical brand redesign called "The Void" — replacing the warm amber/parchment/hand-drawn Caveat aesthetic with a minimalist direction. Everything is committed and pushed.

**Current brand: "The Void"**
- Deep muted navy background (#0C0E14) — not pure black, has subtle blue depth
- Warm beige text (#E8E0D4) — human, not clinical
- Oxidized copper accent (#B87346) — used exclusively for "what's left" (remaining visits, CTAs, active states, hero numbers)
- Typography: New York serif (light weight) for emotional numbers, SF Pro for everything else
- No cards, no shadows, no rounded corners — separation through spacing and hairlines only
- Dark mode forced everywhere
- ALL-CAPS tracked labels for section headers
- All hand-drawn shapes gutted (clean geometry), grain overlay disabled, Caveat font removed from use

**What was done this session:**
1. Design critique by expert panel — identified AI-generated design tells (amber/parchment, Caveat, wobbly shapes, grain)
2. Proposed 3 brand directions: "The Void" (radical minimalism), "The Notebook" (refined analog), "The Monument" (brutalist)
3. Implemented "The Void" — rewrote all theme files + every view
4. Iterated on palette — moved from cold pure black + scarlet to warmer navy + beige + copper based on user feedback
5. Committed and pushed: `4e8c923` on main

**Files changed in this redesign:**
- `Theme/AppColors.swift` — 3-color palette (void navy, bone beige, copper) + metallic relationship colors
- `Theme/AppTypography.swift` — New York serif for numbers, SF Pro for UI, removed Caveat
- `Theme/AppTheme.swift` — Void background, surface sections, hairline dividers (no cards)
- `Views/Components/HandDrawnShapes.swift` — Gutted: clean geometry, grain/wobble disabled
- `Views/Components/HandDrawnProgressRing.swift` — Clean thin circle, copper accent
- `Views/Components/CardStyle.swift` — Flat surface style, no shadows/corners
- `Views/Components/GridVisualization.swift` — Rectangles, past=navy, future=bone
- `Views/Components/ProgressRing.swift` — Thin 2pt stroke, bone white
- `Views/Components/TimePortraitView.swift` — Stark dark portrait, copper number, copper grid
- `Views/Dashboard/DashboardView.swift` — Hero number layout, divider-based sections, no cards
- `Views/Dashboard/StatsCardView.swift` — Minimal number + label, no icon/card
- `Views/LifeCalendar/LifeCalendarView.swift` — Navy bg, copper "weeks left"
- `Views/Onboarding/OnboardingView.swift` — Navy void, copper CTAs, serif reveal
- `Views/People/PersonDetailView.swift` — Copper hero number, progress bar, divider sections
- `Views/Settings/SettingsView.swift` — Dark form, serif age display
- `App/ContentView.swift` — Forced dark mode, copper tab tint, dark nav/tab bar appearance

**What's next:**
1. **Polish pass** — test all flows on simulator, fix any visual issues
2. **BRAND_IDENTITY.md** — needs updating to reflect new "Void" direction (currently describes old Caveat/hand-drawn approach)
3. **Widget** — WidgetKit extension (needs Xcode target + App Group setup)
4. **App Store prep** — screenshots, description, metadata
5. **Visit logging** — deferred feature
6. **Unit tests** — TimeCalculator pure functions

**Design principles (updated):**
- Soul = radical restraint + emotional gut-punch through NUMBERS, not decoration
- The number IS the design — everything else gets out of the way
- Copper = "what's left" (the only accent, the only warmth)
- Navy void = depth without coldness (subtle blue undertone)
- Beige text = human warmth without parchment clichés
- No hand-drawn shapes, no grain, no wobbly anything — clean geometry
- Shareable Time Portrait should look like nothing else on Instagram (stark, dark, a single copper number)

**Git:** https://github.com/zumu-g/timesleft.git (branch: main)
**Simulator:** iPhone 17 Pro, ID: 37557BC1-D0C4-47C5-B40D-84CAB021CB2E
**Bundle ID:** com.timesleft.app

Please review the current codebase state and ask me what I'd like to work on next.

---
