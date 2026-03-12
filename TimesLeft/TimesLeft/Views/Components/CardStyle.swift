import SwiftUI

// MARK: - Card Style — "The Void"
//
// No rounded corners. No shadows. No wobble.
// A subtle surface elevation is the only distinction.

struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 0
    var seed: Int = 0

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.tlSurface)
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 0, seed: Int = 0) -> some View {
        modifier(CardStyle(cornerRadius: cornerRadius, seed: seed))
    }
}
