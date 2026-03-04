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
                    .font(.title)
                    .fontWeight(.bold)

                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}

#Preview {
    HStack {
        StatsCardView(
            title: "People",
            value: "5",
            icon: "person.3.fill",
            color: .blue
        )
        StatsCardView(
            title: "Total Visits",
            value: "342",
            icon: "calendar",
            color: .green
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
