# TimesLeft Brand Identity Document
## Hand-Drawn Illustrated Visual Identity

---

## 1. Brand Essence & Personality

### Brand Voice

TimesLeft speaks like a wise, gentle friend who tells you the truth you need to hear -- not a doctor delivering a diagnosis. It is direct but never cold. It uses plain language, never jargon. It favors the second person ("you") and names ("Mom", "Dad") over abstractions ("the subject", "your contact").

**Voice characteristics:**
- **Honest** -- never sugar-coats the numbers, but frames them with warmth
- **Intimate** -- speaks as if writing a note to one person, not broadcasting
- **Still** -- not loud, not excitable, not peppered with exclamation marks; the quiet confidence of someone who has thought deeply about time
- **Active, not passive** -- "Make it count" not "Time should be valued"

**Phrases that ARE TimesLeft:**
- "This is what's left."
- "Make it count."
- "47 Christmases left with Mom."
- "What if you moved closer?"

**Phrases that are NOT TimesLeft:**
- "Optimize your relationship time!"
- "Don't miss out! Set a reminder now."
- "Your mortality dashboard"
- "Unlock premium insights"

### Emotional Tone Spectrum

On a scale from **somber** to **hopeful**, TimesLeft sits at about **65% toward hopeful**. It acknowledges the weight of finite time, but its purpose is to motivate action, not to create despair. Think of it as the feeling after a meaningful conversation about life -- a little heavy, but clarifying and galvanizing.

The emotional arc across the app experience:

```
Onboarding:     Curious --> Vulnerable --> Gut-punch --> Resolved
Daily use:      Grounded --> Reminded --> Motivated
Sharing:        Reflective --> Connected --> Purposeful
```

### Brand Archetypes

**Primary: The Sage** -- offers uncomfortable truths with compassion
**Secondary: The Caregiver** -- genuinely wants you to deepen your relationships
**Shadow: The Innocent** -- the hand-drawn aesthetic carries a childlike earnestness that makes the heavy content approachable

### Key Emotional Beats the Design Must Hit

1. **The Gut-Punch** (onboarding reveal, first time seeing a number): Stark, quiet, a single number against darkness. The hand-drawn element here is restraint -- maybe a single wobbly underline beneath the number, as if someone circled it in a notebook.

2. **The Tenderness** (daily dashboard, person cards): Warm, held, like looking at a well-worn family photo album. Hand-drawn borders, paper textures, soft edges.

3. **The Urgency Without Panic** (grid visualizations, progress rings): The past is faded, the future is vivid but finite. Not alarming -- just clear.

4. **The Artifact** (shareable Time Portrait): Something you would pin on a fridge or tuck into a journal. Feels made, not generated.

---

## 2. Hand-Drawn Illustration System

### Illustration Style: Loose Ink on Warm Paper

The primary illustration style is **loose single-weight ink line drawings** with occasional **watercolor wash fills** -- think of a thoughtful person's Moleskine notebook or a handwritten letter with small doodles in the margins.

This is NOT:
- Polished vector illustration (too corporate)
- Children's book illustration (too playful for the weight of the subject)
- Medical/clinical illustration (too cold)
- Whimsical doodle art (too unserious)

This IS:
- The kind of drawing a parent might make in a birthday card
- The kind of margin notes in a well-loved book
- Gathered Here's warmth, but with more restraint and stillness

### Line Quality

- **Weight**: Medium-thin, approximately 1.5-2pt equivalent on screen. Not hairline, not bold.
- **Character**: Slightly uneven -- not ruler-straight, but not childishly wobbly either. The hand of someone drawing slowly and intentionally, not quickly and carelessly. Think: the way an architect sketches casually, not the way a toddler draws.
- **Continuity**: Mostly continuous lines with occasional natural breaks where a pen would be lifted. Not perfectly closed shapes -- leave small gaps at corners where lines don't quite meet.
- **Consistency**: All illustrations throughout the app should look like they were drawn by the same person, in the same sitting.

### Implementation: SVG Assets with Organic Paths

All hand-drawn elements should be created as SVG assets and included in the Xcode asset catalog. They should be drawn in a vector tool (Illustrator, Figma, Procreate then vectorized) with intentionally imperfect paths.

**Technique for creating the "hand-drawn" look in vector tools:**
- Draw paths with a slightly textured brush
- Add subtle path roughening (Illustrator: Effect > Distort & Transform > Roughen, Size: 0.5%, Detail: 10, Smooth)
- Export as SVG, import to Xcode asset catalog as template images (so they take tint color)

### What Gets Illustrated

**ALWAYS illustrate (these become part of the visual language):**

1. **Decorative line separators** -- Instead of `Divider()`, use a hand-drawn wavy or slightly curved line SVG
2. **Card borders** -- Instead of `RoundedRectangle(cornerRadius: 16)`, use a hand-drawn rounded rectangle shape that doesn't perfectly close
3. **Icon accents** -- Small drawn elements that accompany or replace SF Symbols in key emotional moments:
   - A hand-drawn heart (not the SF Symbol) for relationship headers
   - A hand-drawn hourglass for the empty state
   - Hand-drawn small stars or dots as decorative accents near numbers
4. **Background textures** -- Subtle paper grain overlay on cards and backgrounds
5. **The grid marks** -- The visit grid dots/squares should be hand-drawn marks (see Section 5)

**NEVER illustrate (keep these clean and functional):**
- Navigation elements (tab bar icons, back buttons, toolbar items)
- Form inputs (text fields, date pickers, buttons)
- System UI (sheets, alerts, share sheets)
- Body text

**SOMETIMES illustrate (context-dependent):**
- Section headers on detail views
- Empty state illustrations
- The Time Portrait (shareable image)

### Illustration Subjects

The illustration vocabulary is deliberately small and symbolic:

| Symbol | Meaning | Where Used |
|--------|---------|------------|
| Small circle/dot (hand-drawn) | One unit of time (visit, week, year) | Grids, life calendar |
| Wavy underline | Emphasis, emotional weight | Under key numbers |
| Small heart | Love, connection | Person cards, relationship headers |
| Simple hourglass | Time passing | Empty states, app icon area |
| Small star/asterisk | Something notable | Special occasions |
| Curved bracket or parenthesis | Holding, containing | Around insight text |
| Simple house outline | Home, proximity | "Move Closer" insight |
| Dotted line / path | Journey, connection between | Between "past" and "future" in grids |

Do NOT illustrate: realistic people, faces, landscapes, complex scenes. The illustrations are marks and symbols, not pictures.

### How Illustrations Interact with Data

This is the key tension: emotional hand-drawn art meets cold statistical numbers.

**The rule: Numbers stay typographic. Context becomes illustrated.**

- The number "47" is always set in the rounded system font, large and clear
- But the phrase "Christmases left" might have a tiny hand-drawn star beside it
- The progress ring stays geometrically precise (it is data)
- But the card it sits in has a hand-drawn border
- The grid squares are hand-drawn marks (they represent individual moments)
- But the count beneath them is typographic

**The effect**: It feels like someone took a clean printout of statistics and then annotated it by hand with care. The data is trustworthy because it is precise; the hand-drawn elements make it feel human because someone cared enough to adorn it.

### Texture and Grain

**Paper grain overlay**: A subtle noise texture (opacity 2-4%) over card backgrounds to suggest paper rather than glass. Implementation in SwiftUI:

```swift
// Paper texture overlay - add to card backgrounds
struct PaperTexture: View {
    var body: some View {
        Canvas { context, size in
            // Draw subtle noise dots
            for _ in 0..<Int(size.width * size.height * 0.003) {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let opacity = Double.random(in: 0.02...0.06)
                let dotSize = CGFloat.random(in: 0.5...1.5)
                context.fill(
                    Path(ellipseIn: CGRect(x: x, y: y, width: dotSize, height: dotSize)),
                    with: .color(.primary.opacity(opacity))
                )
            }
        }
        .allowsHitTesting(false)
    }
}
```

**Edge treatment**: Cards should not have perfectly sharp clip masks. Instead, use SVG mask shapes with slightly irregular edges (hand-drawn rounded rectangles). If SVG masks prove too complex, keep `RoundedRectangle` but add a 1pt hand-drawn border SVG overlaid on top.

---

## 3. Hand-Lettered Typography Direction

### The Typography Hierarchy

TimesLeft uses a three-tier type system:

**Tier 1: System Rounded Font (`.rounded` design)**
- Used for: ALL body text, labels, navigation, buttons, form fields, captions
- Reasoning: Readability, accessibility, system consistency
- Current implementation: Already in place throughout the app -- keep this exactly as-is

**Tier 2: Large Emotional Numbers (System Rounded, oversized)**
- Used for: The big reveal number ("47"), stat card values, life calendar counts
- Reasoning: These numbers carry emotional weight through SIZE and clarity, not through hand-lettering
- Current implementation: `.system(size: 96, weight: .bold, design: .rounded)` -- keep this

**Tier 3: Hand-Lettered Accent Phrases (Custom Font or SVG text)**
- Used for: A small number of specific emotional phrases ONLY
- This is the new layer being added

### Which Text Gets Hand-Lettered

Hand lettering is used sparingly. If everything is hand-lettered, nothing is. These specific phrases deserve hand-lettered treatment:

**Definite hand-lettered phrases (create as SVG assets or use a hand-lettered font):**
1. "Make it count." -- the app's mantra, shown on the onboarding reveal and as a watermark
2. "timesleft" -- the wordmark/logo, shown on the Time Portrait watermark and potentially the app icon
3. "What's left" -- section header alternative
4. "visits left" / "Christmases left" / "summers left" -- the unit labels beneath big numbers on the Time Portrait

**Everything else stays in system rounded font.** Do not hand-letter body text, button labels, navigation titles, form labels, or captions.

### Hand Lettering Style

**Style: Confident casual handwriting, not brush script.**

- Lowercase, not uppercase (uppercase hand lettering feels like shouting)
- Slight baseline irregularity (letters don't sit on a perfect line)
- Consistent letter size (not wildly varying -- this isn't a ransom note)
- Slightly connected letters where natural (the "ti" in "timesleft" might connect)
- No flourishes, no swashes, no decorative extras
- Looks like it was written with a medium-point felt-tip pen (like a Muji 0.5mm)

**Reference feel**: The handwriting of someone who writes thoughtfully in a journal. Not calligraphy. Not a child's writing. Not a designer showing off. Just a human hand.

### Implementation Approach

**Option A (Recommended): Custom Hand-Lettered Font**
Commission or source a hand-lettered font (candidates: Caveat, Patrick Hand, Kalam from Google Fonts -- all free). Import as a custom font in the Xcode project. Use it ONLY for the phrases listed above.

```swift
// Example usage -- ONLY for specific emotional phrases
extension Font {
    static func handLettered(size: CGFloat) -> Font {
        .custom("Caveat-Regular", size: size)  // or chosen hand-lettered font
    }
    static func handLetteredBold(size: CGFloat) -> Font {
        .custom("Caveat-Bold", size: size)
    }
}

// Usage in views:
Text("Make it count.")
    .font(.handLettered(size: 22))
    .foregroundStyle(.white.opacity(0.6))
```

**Option B: SVG Text Assets**
For the wordmark "timesleft" and the phrase "Make it count.", create hand-drawn SVG assets. This gives more control over exact appearance but is less flexible for dynamic text like "visits left with Mom."

**Recommended combination**: Use a hand-lettered font (Option A) for dynamic phrases like "visits left" and "Christmases left." Use SVG assets (Option B) for the fixed wordmark "timesleft" and the fixed phrase "Make it count."

### How Hand Lettering Creates Emotional Weight

The hand-lettered phrases function as **marginalia** -- the notes someone writes in the margins of a book they care about. When you see "47" in a big bold system font and then "visits left" in handwriting beneath it, the contrast creates a specific emotional response:

- The number is factual, undeniable, clinical in its precision
- The handwriting is personal, someone interpreting that fact, a human presence responding to the data
- Together, they say: "This is real, and someone cares about it"

This contrast is the beating heart of the visual identity. Do not undermine it by hand-lettering everything (makes it feel like a greeting card) or by removing it (makes it feel like a spreadsheet).

---

## 4. Color Palette

### Primary Palette

| Role | Color | Hex | RGB | Usage |
|------|-------|-----|-----|-------|
| **Amber (Primary Accent)** | Warm amber/coral | `#ED9452` | R:0.93 G:0.58 B:0.32 | Primary accent, future time, buttons, active elements |
| **Cream (Light Background)** | Warm off-white | `#FAF6F1` | R:0.98 G:0.96 B:0.95 | Light mode card backgrounds, paper texture base |
| **Charcoal (Dark Background)** | Warm near-black | `#1A1816` | R:0.10 G:0.09 B:0.09 | Dark mode backgrounds (NOT pure #000000) |
| **Warm Gray (Secondary Text)** | Muted warm gray | `#8A8078` | R:0.54 G:0.50 B:0.47 | Secondary labels, past-tense text, legends |
| **Ink (Primary Text - Light)** | Warm dark brown-black | `#2C2825` | R:0.17 G:0.16 B:0.15 | Primary text in light mode |

### Evolving the Amber

Keep the existing warm amber (`#ED9452`) as the primary accent. It is already distinctive and emotionally correct -- warm without being aggressive, visible without being alarming.

**Add these supporting accent shades:**

| Shade | Hex | Usage |
|-------|-----|-------|
| Amber Light | `#F5B882` | Hover/pressed states, secondary accent elements, "glow" effects |
| Amber Faded | `#ED945233` (20% opacity) | Background tints for insight cards, section highlights |
| Amber Whisper | `#ED94520F` (6% opacity) | Subtle card background warmth |

### Background Evolution: From Pure Black to Warm Dark

**Critical change**: Replace `Color.black` with a warm charcoal (`#1A1816`) throughout. Pure black feels clinical and tech-product. Warm charcoal feels like a darkened room, like nighttime, like intimacy.

For the onboarding reveal and Time Portrait, continue using very dark backgrounds, but warm ones:

```swift
// Replace this:
Color.black.ignoresSafeArea()

// With this:
Color(red: 0.10, green: 0.09, blue: 0.09).ignoresSafeArea()
```

For light mode cards, use cream (`#FAF6F1`) instead of system gray backgrounds to feel more like paper:

```swift
// Current:
Color(UIColor.secondarySystemGroupedBackground)

// Evolved (define as an extension):
extension Color {
    static let cardBackground = Color(red: 0.98, green: 0.96, blue: 0.95)
    static let warmBlack = Color(red: 0.10, green: 0.09, blue: 0.09)
}
```

### Color for Past vs. Future

| State | Color Treatment | Emotional Meaning |
|-------|----------------|-------------------|
| **Past / Spent time** | `Color.warmGray.opacity(0.12)` -- barely visible, warm gray | Time that has evaporated. Not sad, just gone. Like pencil marks that have been erased. |
| **Future / Remaining time** | `Color.amber` (full accent) | Vivid, present, available. Each mark is a real opportunity. |
| **The present moment** | Slightly larger mark or a subtle pulse | "You are here." |
| **Unknown / not yet entered** | `Color.warmGray.opacity(0.06)` -- ghost marks | Potential time not yet assigned to anyone. |

### How Hand-Drawn Textures Interact with Color

- Hand-drawn line work should be in `Ink` color in light mode, `cream.opacity(0.7)` in dark mode
- Watercolor wash fills (if used) should use Amber at 15-25% opacity -- suggesting warmth without competing with data
- Paper texture grain should be in the primary text color at 2-4% opacity
- Hand-drawn borders around cards should be slightly darker than the card background, never the accent color (the accent is reserved for data meaning)

---

## 5. Signature Visual Moments

### 5A. The Onboarding Reveal

**Current**: Big "47" in amber on pure black, grid of colored squares, "This is what's left. Make it count."

**Evolved with hand-drawn elements:**

The reveal sequence should feel like opening a sealed letter that someone wrote to you about your life.

**Screen 1-2 (Ask Age, Ask Frequency):**
- Keep the dark background (now warm charcoal, not pure black)
- Add a very subtle paper texture overlay (2% opacity noise)
- Input fields: Replace the current `RoundedRectangle` backgrounds with hand-drawn rectangle SVGs -- slightly wobbly borders, warm cream fill at 8% opacity
- "Think of someone you love." -- keep in system rounded font, but add a small hand-drawn heart SVG after the period, subtle, about 14pt, in amber at 50% opacity

**Screen 3 (The Reveal) -- the emotional peak:**

```
[warm charcoal background with subtle paper grain]

         [hand-drawn wavy underline in amber, fades in first]

                        47
              [huge, system rounded bold, amber]

         [hand-drawn wavy underline appears beneath]

         visits left with Mom.
         [hand-lettered font, white at 70% opacity]

    [grid of hand-drawn dots fades in, row by row]
    . . . . . . . . . . . . . . . . . . . .
    . . . . . . . . . . . . . . . . . . . .
    [past dots: warm gray at 12%, future dots: amber]
    [each dot is a small imperfect circle, not a square]
    [dots are slightly different sizes, 3-5pt range]
    [slight random position jitter, +/-0.5pt]

         Make it count.
         [hand-lettered, white at 50% opacity]
         [small hand-drawn asterisk or star before the phrase]
```

**Implementation notes:**
- The wavy underline beneath "47" is an SVG asset, animated to draw itself (use `trim(from:to:)` animation on a Path)
- The dots use a Canvas view (like the current `WeeksCanvasGrid`) but draw imperfect circles instead of rectangles
- Each dot has slight size and position randomness seeded by its index (so it is deterministic, not different on every render)

```swift
// Hand-drawn dot rendering in Canvas
for index in 0..<cellCount {
    let col = index % columns
    let row = index / columns
    let seed = Double(index)
    let jitterX = CGFloat(sin(seed * 1.7)) * 0.5
    let jitterY = CGFloat(cos(seed * 2.3)) * 0.5
    let sizeVariation = CGFloat(3.0 + sin(seed * 3.1) * 1.0) // 2pt to 4pt

    let center = CGPoint(
        x: CGFloat(col) * spacing + jitterX + spacing / 2,
        y: CGFloat(row) * spacing + jitterY + spacing / 2
    )

    let dotPath = Path(ellipseIn: CGRect(
        x: center.x - sizeVariation / 2,
        y: center.y - sizeVariation / 2,
        width: sizeVariation,
        height: sizeVariation
    ))

    let isPast = index < pastCount
    context.fill(dotPath, with: .color(isPast ? pastColor : futureColor))
}
```

### 5B. The Visit Grid (PersonDetailView)

**Current**: `LazyVGrid` of perfect `RoundedRectangle` squares.

**Evolved**: Hand-drawn dots in a Canvas view (same approach as onboarding).

- Replace perfect squares with imperfect circles (ellipses with slight width/height variation)
- Add position jitter (deterministic, seeded by index)
- Past dots: warm gray at 12% opacity
- Future dots: amber at full opacity
- The transition point (where past meets future) could have a slightly larger dot or a different shape (a small X or asterisk) to mark "you are here"
- Keep the dot size small (3-4pt with +/- 1pt variation) so the grid reads as a texture/pattern from a distance

**The "you are here" marker:**
```swift
// At the transition between past and future
if index == pastCount {
    // Draw a slightly larger mark, perhaps an X or a filled dot with a ring
    let markerSize: CGFloat = 6.0
    context.stroke(
        Path(ellipseIn: CGRect(
            x: center.x - markerSize/2,
            y: center.y - markerSize/2,
            width: markerSize,
            height: markerSize
        )),
        with: .color(.white.opacity(0.6)),
        lineWidth: 1.0
    )
}
```

### 5C. The Shareable Time Portrait

**Current**: Dark background, grid, number, watermark. Clean but indistinguishable from a screenshot.

**Evolved**: Should feel like a handmade broadside print or a letterpress card.

**Layout:**

```
+--[hand-drawn border, slightly irregular]--+
|                                            |
|  [paper texture background, warm charcoal] |
|                                            |
|           M O M                            |
|     [tracked uppercase, system rounded]    |
|                                            |
|   [hand-drawn dots grid, as described]     |
|   . . . . . . . . . . . . . . . . . . .   |
|   . . . . . . . . . . . . . . . . . . .   |
|   . . . . . . . . . . . . . . . . . . .   |
|                                            |
|              47                            |
|   [huge number, system rounded bold]       |
|                                            |
|       visits left together.                |
|   [hand-lettered font, muted white]       |
|                                            |
|   ~~~ [hand-drawn wavy line separator] ~~~ |
|                                            |
|          timesleft                         |
|   [hand-lettered wordmark SVG, very muted] |
|                                            |
+--------------------------------------------+
```

**Key differences from current:**
1. **Hand-drawn border**: An SVG frame/border that looks drawn with a pen, not a perfect rectangle. Slightly rounded corners that don't meet perfectly. In cream/white at 10-15% opacity.
2. **Dots instead of squares**: Same hand-drawn dot grid as described above.
3. **Hand-lettered unit label**: "visits left together." in the hand-lettered font.
4. **Hand-drawn separator**: A wavy line SVG between the stats and the watermark.
5. **Hand-lettered wordmark**: "timesleft" as an SVG asset in the hand-lettered style, not system font.
6. **Background**: Warm charcoal with paper grain, not pure black.

**Why this matters for sharing**: When someone posts this to Instagram Stories, it should look like a hand-crafted artifact -- something someone made with care, not a screenshot from an app. This is the difference between "oh, another app graphic" and "what IS that? I want to make one."

### 5D. The Life Calendar (4000 Weeks)

**Current**: Canvas-based grid of tiny rectangular cells.

**Evolved**: Each week is a tiny hand-drawn dot. At this scale (4000+ marks), the individual imperfections create a beautiful organic texture that looks like a hand-stamped or risograph-printed poster.

**Implementation:**
- Use the same Canvas approach but with the imperfect circle rendering
- At this density, reduce jitter (position variation +/- 0.3pt max) so the grid still reads as organized
- Size variation: 1.5-2.5pt range (subtle at this scale)
- The transition between lived weeks and remaining weeks creates a visible "coastline" -- a ragged organic boundary that is more emotionally evocative than a clean straight line
- Consider adding year markers every 52 dots: a tiny tick mark or slight gap on the left edge, like ruled notebook lines

**Year markers (optional but recommended):**
```swift
// Every 52 weeks (each row), draw a faint tick on the left margin
if week % 52 == 0 {
    let yearNumber = week / 52
    // Draw a tiny year label every 10 years
    if yearNumber % 10 == 0 {
        context.draw(
            Text("\(yearNumber)")
                .font(.system(size: 6))
                .foregroundColor(.secondary.opacity(0.4)),
            at: CGPoint(x: -12, y: yPos + cellSize / 2)
        )
    }
}
```

### 5E. Empty States

**Current**: SF Symbol hourglass icon, system text, bordered button.

**Evolved**: This is where hand-drawn illustration shines most. Empty states are emotional moments -- the user has opened the app but hasn't added anyone yet, or has navigated to a section with no data.

**Dashboard empty state:**
- Replace the SF Symbol hourglass with a hand-drawn hourglass SVG illustration (approximately 80pt, centered)
- The hourglass should be drawn in a single continuous line style, amber color
- "Make Time Count" in system rounded bold (keep)
- The description text stays in system font (keep)
- Below the description, add a small hand-drawn arrow SVG pointing down toward the button, as if sketched in

**People list empty state:**
- A hand-drawn illustration of two simple figures (stick-figure level simplicity, not detailed) facing each other with a dotted line between them suggesting connection
- "Add someone you love" in system rounded font
- Small hand-drawn heart near the text

### 5F. Loading States and Transitions

**Loading:**
- Instead of a system spinner, use a slowly pulsing hand-drawn dot (the same imperfect circle used in grids)
- The dot gently scales from 0.9 to 1.1 and fades from 40% to 80% opacity in a 2-second loop
- This feels like a heartbeat, not a loading indicator

**Transitions between views:**
- Keep using `.opacity` transitions (current approach)
- When the onboarding reveal number appears, add a subtle scale animation from 0.95 to 1.0 so it feels like it is breathing into existence
- Grid dots should animate in with a staggered row-by-row fade (current approach is good, keep it)

### 5G. Card Borders and Containers

**Current**: `RoundedRectangle(cornerRadius: 16)` with shadow.

**Evolved**: Two options depending on context:

**Option A -- Subtle hand-drawn border (for primary content cards):**
Create an SVG of a hand-drawn rounded rectangle. Use it as an overlay on cards. The SVG should be a 9-slice-compatible shape (or use `ResizableShape` in SwiftUI) so it scales to any card size.

```swift
struct HandDrawnCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.cardBackground)
            .overlay(
                Image("hand-drawn-border")  // SVG asset
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.primary.opacity(0.08))
            )
            .shadow(color: .black.opacity(0.04), radius: 12, y: 6)
    }
}
```

**Option B -- Clean card with hand-drawn accent (simpler to implement):**
Keep the current `RoundedRectangle` card shape but add a hand-drawn decorative element inside: a small illustration in the corner, or a hand-drawn divider line between sections within the card.

**Recommendation**: Start with Option B (easier, lower risk of visual clutter) and evolve to Option A if the app's visual identity develops further.

---

## 6. Asset Checklist for Implementation

### SVG Assets to Create

| Asset Name | Description | Size Guidance | Usage |
|-----------|-------------|---------------|-------|
| `heart-drawn` | Simple hand-drawn heart | 24x24pt base | Person cards, onboarding |
| `hourglass-drawn` | Hand-drawn hourglass, single line | 80x80pt base | Empty state |
| `underline-wavy` | Wavy underline stroke | 120x8pt base, stretchable | Beneath reveal number |
| `separator-wavy` | Wavy horizontal line | 200x4pt base, stretchable | Between sections |
| `border-card` | Hand-drawn rounded rectangle | 300x200pt base, 9-slice | Card borders (Phase 2) |
| `star-small` | Hand-drawn asterisk/star | 16x16pt base | Special occasions, accents |
| `arrow-down` | Hand-drawn downward arrow | 24x40pt base | Empty state CTA |
| `wordmark-timesleft` | "timesleft" hand-lettered | 120x24pt base | Time Portrait watermark |
| `make-it-count` | "Make it count." hand-lettered | 160x24pt base | Onboarding reveal, empty state |
| `border-portrait` | Hand-drawn portrait frame | 390x690pt (share size) | Time Portrait border |

### Font Assets

| Font | Source | License | Usage |
|------|--------|---------|-------|
| Caveat Regular | Google Fonts | OFL (free) | Hand-lettered phrases |
| Caveat Bold | Google Fonts | OFL (free) | Emphasized hand-lettered phrases |

(Alternative candidates if Caveat doesn't feel right: Kalam, Patrick Hand, Architects Daughter -- all OFL licensed from Google Fonts. Test each in the context of the amber-on-dark palette before committing.)

### Color Constants to Define

```swift
import SwiftUI

extension Color {
    // Brand palette
    static let amber = Color(red: 0.93, green: 0.58, blue: 0.32)         // #ED9452
    static let amberLight = Color(red: 0.96, green: 0.72, blue: 0.51)    // #F5B882
    static let amberFaded = amber.opacity(0.20)
    static let amberWhisper = amber.opacity(0.06)

    // Backgrounds
    static let warmBlack = Color(red: 0.10, green: 0.09, blue: 0.09)     // #1A1816
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.95)         // #FAF6F1
    static let cardBackground = Color(red: 0.98, green: 0.96, blue: 0.95) // same as cream, alias

    // Text
    static let ink = Color(red: 0.17, green: 0.16, blue: 0.15)           // #2C2825
    static let warmGray = Color(red: 0.54, green: 0.50, blue: 0.47)      // #8A8078

    // Grid states
    static let timePast = Color(red: 0.54, green: 0.50, blue: 0.47).opacity(0.12)
    static let timeFuture = amber
    static let timeGhost = Color(red: 0.54, green: 0.50, blue: 0.47).opacity(0.06)
}

extension Font {
    static func handLettered(size: CGFloat) -> Font {
        .custom("Caveat-Regular", size: size)
    }
    static func handLetteredBold(size: CGFloat) -> Font {
        .custom("Caveat-Bold", size: size)
    }
}
```

---

## 7. Implementation Priority

### Phase 1 -- Quick Wins (1-2 hours)

1. **Replace `Color.black` with `Color.warmBlack`** throughout all dark screens (onboarding, Time Portrait)
2. **Define the color palette** as a `Color` extension file
3. **Add paper texture** overlay to card backgrounds (the `PaperTexture` Canvas view)
4. **Add the hand-lettered font** (download Caveat from Google Fonts, add to Xcode project, create `Font` extension)
5. **Apply hand-lettered font** to "Make it count." and "visits left" phrases only

### Phase 2 -- Grid Evolution (2-3 hours)

6. **Replace grid rectangles with hand-drawn dots** in all grid views (onboarding reveal, PersonDetailView, Time Portrait)
7. **Add "you are here" marker** at the transition point in grids
8. **Update Life Calendar** to use imperfect dots with year markers

### Phase 3 -- Illustrated Assets (requires designer or SVG creation, 4-8 hours)

9. **Create SVG assets** (heart, hourglass, wavy underline, separator, wordmark)
10. **Update empty states** with hand-drawn illustrations
11. **Add wavy underline** to the reveal number animation
12. **Update Time Portrait** with hand-drawn border and wordmark

### Phase 4 -- Refinement (ongoing)

13. **Card border evolution** (hand-drawn borders if Phase 3 looks good)
14. **Loading state** heartbeat dot
15. **Micro-interactions** and transition polish

---

## 8. What This Is NOT

To prevent scope creep and maintain the app's soul, here is what this brand identity explicitly excludes:

- **Animations for entertainment** -- Every animation serves an emotional purpose (revealing, connecting, breathing). No bouncing, spinning, or confetti.
- **Illustration-heavy screens** -- This is not an illustrated storybook app. Illustrations are accents, not the main content.
- **Skeuomorphism** -- We are not simulating a physical notebook or paper journal. We are borrowing the warmth of hand-drawn marks while remaining a modern digital interface.
- **Inconsistency for the sake of "handmade"** -- The hand-drawn elements should be consistent (same line weight, same jitter parameters, same dot style). Randomness is controlled and seeded, not chaotic.
- **Brand elements that compete with data** -- The most important thing on any screen is the NUMBER. The hand-drawn elements frame, contextualize, and warm the numbers. They never distract from them.

---

*This document is the source of truth for TimesLeft's visual identity. Every design decision should be tested against the question: "Does this make the app feel like something a caring friend made by hand to help you see your time more clearly?"*
