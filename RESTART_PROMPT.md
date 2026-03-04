# TimesLeft - Session Restart Prompt

Copy and paste this to continue where we left off:

---

## Prompt:

We're continuing work on the TimesLeft iOS app. Here's where we are:

**Last session (2026-03-04):** We completed a major Phase 2 overhaul. The app builds and runs on simulator. Key changes:
- Emotional 4-screen onboarding flow (ask parent → frequency → animated gut-punch reveal → profile setup)
- UserProfile model replacing hardcoded yourAge=30
- Warm amber/coral visual identity (no more traffic-light progress rings)
- Shareable Time Portrait (dark Instagram-style visualization with share sheet)
- Canvas-based Life Calendar (4,000 weeks grid)
- "Move Closer" dashboard insight
- Tail End insights extended to all relationship types
- Fixed special occasions (no longer all identical numbers)

**What still needs doing:**
1. **WidgetKit extension** - Needs Xcode target setup (App Group + Widget Extension). Small widget showing one rotating daily stat like "47 Christmases left with Mom"
2. **User testing feedback** - I tested the app on simulator, fix any issues I report
3. **App Store prep** - Screenshots, app description, metadata
4. **Unit tests** - TimeCalculator tests (pure functions, easy to test)
5. **README/docs update** - Reflect Phase 2 completion

**Design principles to maintain:**
- Soul = simplicity + emotional gut-punch + finite time with PEOPLE (not activities)
- No gamification, no social feeds, no activity tracking
- Every feature should either create an emotional moment or enable sharing

**Git:** https://github.com/zumu-g/timesleft.git (branch: main)

Please review the current codebase state and ask me what I'd like to work on next.

---
