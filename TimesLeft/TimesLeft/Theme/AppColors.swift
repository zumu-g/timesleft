import SwiftUI

// MARK: - TimesLeft Color System — "The Void"
//
// Deep muted navy + warm beige text + oxidized copper accent.
// The darkness has depth. The light has warmth. The copper has urgency.

extension Color {

    // =========================================================================
    // MARK: 1. CORE PALETTE
    // =========================================================================

    /// The void — deep muted navy. Darkness with depth, not a dead screen.
    /// Like the sky 30 minutes after sunset. There's still color in the dark.
    /// Hex: #0C0E14
    static let tlVoid = Color(red: 0.047, green: 0.055, blue: 0.078)

    /// Bone — warm beige/cream. Text that feels human, not clinical.
    /// Like aged paper under lamplight.
    /// Hex: #E8E0D4
    static let tlBone = Color(red: 0.91, green: 0.88, blue: 0.83)

    /// Copper — oxidized, aged, warm. The accent that means "what's left."
    /// Like a penny found in a coat pocket. Patina, not polish.
    /// Hex: #B87346
    static let tlCopper = Color(red: 0.72, green: 0.45, blue: 0.27)

    // =========================================================================
    // MARK: 2. FUNCTIONAL TOKENS
    // =========================================================================

    /// Primary text — warm beige on the navy void.
    static let tlTextPrimary = Color.tlBone

    /// Secondary text — muted warm gray with a hint of blue.
    /// Readable but receding. Captions, labels, supporting info.
    /// Hex: #6B6D78
    static let tlTextSecondary = Color(red: 0.42, green: 0.43, blue: 0.47)

    /// Tertiary text — barely there. Section headers, watermarks.
    /// Hex: #3A3C44
    static let tlTextTertiary = Color(red: 0.23, green: 0.24, blue: 0.27)

    /// The primary background — the void.
    static let tlBackground = Color.tlVoid

    /// Subtle surface elevation — slightly lighter navy for sections.
    /// Hex: #12141C
    static let tlSurface = Color(red: 0.071, green: 0.078, blue: 0.110)

    /// Hairline dividers and borders — a faint navy line.
    /// Hex: #1E2030
    static let tlDivider = Color(red: 0.12, green: 0.13, blue: 0.19)

    /// Past time — faded into the void. Already gone.
    /// Hex: #1A1C26
    static let tlPast = Color(red: 0.10, green: 0.11, blue: 0.15)

    /// Future time — warm bone. What remains.
    static let tlFuture = Color.tlBone

    /// The accent — copper. Only for remaining-time emphasis.
    static let tlAccent = Color.tlCopper

    // =========================================================================
    // MARK: 3. RELATIONSHIP COLORS — Warm metallic tones
    // =========================================================================
    // Subtle variations on the copper/bronze family.
    // Each relationship has its own warmth without breaking the palette.

    /// Parent — deep copper, the warmth of origin.
    static let tlRelParent = Color(red: 0.78, green: 0.52, blue: 0.35)

    /// Partner — warm rose-copper, intimate.
    static let tlRelPartner = Color(red: 0.75, green: 0.48, blue: 0.45)

    /// Friend — golden bronze, chosen warmth.
    static let tlRelFriend = Color(red: 0.76, green: 0.60, blue: 0.38)

    /// Sibling — sienna copper, shared roots.
    static let tlRelSibling = Color(red: 0.70, green: 0.50, blue: 0.38)

    /// Child — soft light copper, tender.
    static let tlRelChild = Color(red: 0.82, green: 0.62, blue: 0.45)

    /// Grandparent — aged bronze, deep.
    static let tlRelGrandparent = Color(red: 0.60, green: 0.48, blue: 0.38)

    /// Other — muted warm gray.
    static let tlRelOther = Color(red: 0.55, green: 0.52, blue: 0.48)

    static func relationshipColor(for type: RelationshipType) -> Color {
        switch type {
        case .parent:       return .tlRelParent
        case .partner:      return .tlRelPartner
        case .friend:       return .tlRelFriend
        case .sibling:      return .tlRelSibling
        case .child:        return .tlRelChild
        case .grandparent:  return .tlRelGrandparent
        case .other:        return .tlRelOther
        }
    }

    // =========================================================================
    // MARK: 4. LEGACY ALIASES
    // =========================================================================

    static let tlAmber = Color.tlCopper
    static let tlScarlet = Color.tlCopper
    static let tlCharcoal = Color.tlVoid
    static let tlInsight = Color.tlTextSecondary
    static let tlCardBackground = Color.tlSurface
    static let tlDarkBackground = Color.tlVoid
    static let tlPortraitBackground = Color.tlVoid
    static let tlTextOnDark = Color.tlBone
    static let tlTextMutedOnDark = Color.tlTextSecondary
    static let tlTextAccent = Color.tlCopper
    static let tlShadow = Color.clear

    static func tlAdaptiveBackground(_ scheme: ColorScheme) -> Color { .tlBackground }
    static func tlAdaptiveCard(_ scheme: ColorScheme) -> Color { .tlSurface }
    static func tlAdaptiveText(_ scheme: ColorScheme) -> Color { .tlTextPrimary }
    static func tlAdaptiveSecondaryText(_ scheme: ColorScheme) -> Color { .tlTextSecondary }
    static func tlAdaptivePast(_ scheme: ColorScheme) -> Color { .tlPast }
}
