import SwiftUI

// MARK: - TimesLeft Typography — "The Void"
//
// Two voices only:
// 1. NEW YORK (serif) — for the numbers that matter. The weight of counting.
// 2. SF PRO (system) — for everything else. Clean, invisible, functional.
//
// No decorative fonts. No Caveat. The restraint IS the personality.

extension Font {

    // MARK: - Serif numbers (New York) — used ONLY for emotional reveals

    /// The hero number — 120pt. Fills the screen. IS the screen.
    static let tlHeroNumber: Font = .system(size: 120, weight: .light, design: .serif)

    /// Large display number — Time Portrait, secondary reveals (72pt)
    static let tlDisplayNumber: Font = .system(size: 72, weight: .light, design: .serif)

    /// Medium display — dashboard featured number (48pt)
    static let tlFeatureNumber: Font = .system(size: 48, weight: .light, design: .serif)

    /// Stat number — card values (32pt)
    static let tlStatLarge: Font = .system(size: 32, weight: .light, design: .serif)

    /// Inline stat — smaller contexts (22pt)
    static let tlStatMedium: Font = .system(size: 22, weight: .regular, design: .serif)

    /// Small stat (17pt)
    static let tlStatSmall: Font = .system(size: 17, weight: .medium, design: .serif)

    // MARK: - System text (SF Pro) — clean, invisible, functional

    /// Screen title (28pt)
    static let tlTitle: Font = .system(size: 28, weight: .semibold, design: .default)

    /// Section title (22pt)
    static let tlTitle2: Font = .system(size: 22, weight: .semibold, design: .default)

    /// Subsection title (20pt)
    static let tlTitle3: Font = .system(size: 20, weight: .medium, design: .default)

    /// Headline — section headers, emphasis (17pt semibold)
    static let tlHeadline: Font = .system(size: 17, weight: .semibold, design: .default)

    /// Body text (17pt)
    static let tlBody: Font = .system(size: 17, weight: .regular, design: .default)

    /// Body medium (17pt medium)
    static let tlBodyMedium: Font = .system(size: 17, weight: .medium, design: .default)

    /// Subheadline (15pt)
    static let tlSubheadline: Font = .system(size: 15, weight: .regular, design: .default)

    /// Caption (13pt)
    static let tlCaption: Font = .system(size: 13, weight: .regular, design: .default)

    /// All-caps label — small, tracked out, authoritative (11pt)
    static let tlLabel: Font = .system(size: 11, weight: .medium, design: .default)

    // MARK: - Ring typography

    static func tlRingPercentage(ringSize: CGFloat) -> Font {
        .system(size: ringSize * 0.22, weight: .light, design: .serif)
    }

    static func tlRingLabel(ringSize: CGFloat) -> Font {
        .system(size: ringSize * 0.10, weight: .regular, design: .default)
    }

    // MARK: - Legacy aliases

    static let tlDisplayText: Font = .system(size: 28, weight: .light, design: .serif)
    static let tlHandAccent: Font = .system(size: 17, weight: .regular, design: .default)
    static let tlPersonName: Font = .system(size: 15, weight: .medium, design: .default)
    static let tlPersonNameHand: Font = .system(size: 22, weight: .light, design: .serif)
    static let tlWatermark: Font = .system(size: 11, weight: .regular, design: .default)

    static func handDrawn(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
}

// MARK: - Text Style Modifiers

extension View {
    /// The hero number — serif, scarlet, enormous.
    func heroNumberStyle() -> some View {
        self.font(.tlHeroNumber)
            .foregroundStyle(Color.tlBone)
            .minimumScaleFactor(0.5)
    }

    /// Display number — serif, bone white.
    func displayNumberStyle() -> some View {
        self.font(.tlDisplayNumber)
            .foregroundStyle(Color.tlBone)
    }

    /// Emotional message — secondary text, centered.
    func emotionalMessageStyle() -> some View {
        self.font(.tlSubheadline)
            .foregroundStyle(Color.tlTextSecondary)
            .multilineTextAlignment(.center)
    }

    /// Watermark — barely there.
    func watermarkStyle() -> some View {
        self.font(.tlWatermark)
            .foregroundStyle(Color.tlTextTertiary)
            .tracking(2)
            .textCase(.uppercase)
    }
}
