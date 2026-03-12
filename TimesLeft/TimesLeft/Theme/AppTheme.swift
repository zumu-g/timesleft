import SwiftUI

// MARK: - AppTheme — "The Void"
//
// No cards. No shadows. No borders.
// Content floats on darkness. Separation through spacing alone.

// MARK: - Void Background

struct VoidBackground: ViewModifier {
    func body(content: Content) -> some View {
        content.background(Color.tlBackground.ignoresSafeArea())
    }
}

// MARK: - Surface Section (subtle elevation)

struct SurfaceStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tlSurface)
    }
}

// MARK: - Divider

struct VoidDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.tlDivider)
            .frame(height: 0.5)
    }
}

// MARK: - Legacy Card Styles (bridge)

struct ThemedCardStyle: ViewModifier {
    var cornerRadius: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tlSurface)
    }
}

struct InsightCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tlSurface)
    }
}

struct UrgencyCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tlSurface)
    }
}

// MARK: - View Extensions

extension View {
    func voidBackground() -> some View {
        modifier(VoidBackground())
    }

    func surfaceStyle() -> some View {
        modifier(SurfaceStyle())
    }

    func themedCard(cornerRadius: CGFloat = 0) -> some View {
        modifier(ThemedCardStyle(cornerRadius: cornerRadius))
    }

    func insightCard() -> some View {
        modifier(InsightCardStyle())
    }

    func urgencyCard() -> some View {
        modifier(UrgencyCardStyle())
    }

    func themedBackground() -> some View {
        modifier(VoidBackground())
    }
}
