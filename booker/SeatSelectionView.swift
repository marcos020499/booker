import SwiftUI

struct SeatSelectionView: View {
    let fareFamily: String
    @Binding var selectedSeat: String?
    @Environment(\.dismiss) var dismiss

    let firstClassSeats = [
        ["1A", "1B", "", "1C", "1D"],
        ["2A", "2B", "", "2C", "2D"]
    ]
    
    let businessSeats = [
        ["3A", "3B", "", "3C", "3D"],
        ["4A", "4B", "", "4C", "4D"],
        ["5A", "5B", "", "5C", "5D"]
    ]
    
    let economySeats = [
        ["6A", "6B", "6C", "", "6D", "6E", "6F"],
        ["7A", "7B", "7C", "", "7D", "7E", "7F"],
        ["8A", "8B", "8C", "", "8D", "8E", "8F"],
        ["9A", "9B", "9C", "", "9D", "9E", "9F"],
        ["10A", "10B", "10C", "", "10D", "10E", "10F"],
        ["11A", "11B", "11C", "", "11D", "11E", "11F"],
        ["12A", "12B", "12C", "", "12D", "12E", "12F"]
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Select Your Seat")
                    .font(.title)
                    .bold()
                    .padding()

                ScrollView(.horizontal, showsIndicators: false) {
                    VStack(spacing: 20) {
                        seatSection(title: "First Class", seats: firstClassSeats, color: .orange, spacing: 30)
                        seatSection(title: "Business Class", seats: businessSeats, color: .blue, spacing: 20)
                        seatSection(title: "Economy Class", seats: economySeats, color: .green, spacing: 10)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }

    func seatSection(title: String, seats: [[String]], color: Color, spacing: CGFloat) -> some View {
        VStack {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
            
            ForEach(seats, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { seat in
                        if seat.isEmpty {
                            Spacer().frame(width: 40)
                        } else {
                            seatButton(seat: seat)
                        }
                    }
                }
            }
        }
    }

    func seatButton(seat: String) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                selectedSeat = seat
                dismiss()
            }
        }) {
            VStack {
                Image(systemName: "chair.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .foregroundColor(seatColor(for: seat))
                    .scaleEffect(selectedSeat == seat ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: selectedSeat)

                Text(seat)
                    .font(.caption2)
                    .foregroundColor(.black)
            }
            .frame(width: 40, height: 40)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            .padding(.horizontal, 2)
        }
    }

    func seatColor(for seat: String) -> Color {
        if seat == selectedSeat {
            return .red
        }
        switch seat.first {
        case "1", "2": return Color.orange.opacity(0.8)
        case "3", "4", "5": return Color.blue.opacity(0.7)
        default: return Color.green.opacity(0.7)
        }
    }
}

