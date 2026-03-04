import SwiftUI

struct StatsCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(.title, design: .rounded, weight: .bold))

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
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
    .background(Color(UIColor.systemGroupedBackground))
}
