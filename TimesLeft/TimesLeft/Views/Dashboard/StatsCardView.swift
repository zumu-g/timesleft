import SwiftUI

// MARK: - Stats Card — "The Void"
//
// Minimal. Number + label. No icon, no color, no card.

struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.tlStatLarge)
                .foregroundStyle(Color.tlBone)

            Text(title.uppercased())
                .font(.tlLabel)
                .foregroundStyle(Color.tlTextTertiary)
                .tracking(1.5)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    HStack {
        StatsCardView(
            title: "People",
            value: "5",
            icon: "person.3.fill",
            color: .accentColor
        )
        StatsCardView(
            title: "Total Visits",
            value: "342",
            icon: "calendar",
            color: .accentColor
        )
    }
    .padding()
    .background(Color.tlBackground)
}
