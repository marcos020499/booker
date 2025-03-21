import SwiftUI

struct AirportButton: View {
    var label: String
    var airport: Airport?
    var icon: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                airport == nil ?
                Text("\(label)")
                    .foregroundColor(.black)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                :
                Text("\(airport?.name ?? "Select")")
                    .foregroundColor(.white)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(airport == nil ? .black : .white)
            }
            .padding()
            .frame(height: 80)
            .background(airport == nil ? Color.white : .blue)
            .cornerRadius(8)
        }
    }
}
