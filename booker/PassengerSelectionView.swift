import SwiftUI

struct PassengerSelectionView: View {
    @Binding var passengerInfo: PassengerInfo
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            // Title
            Text("Passenger Selection")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 30)
            
            Text("Select the number of passengers for your trip.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            // Passenger selection section
            VStack(spacing: 25) {
                PassengerStepper(label: "Adults", subtitle: "Ages 12 and above", count: $passengerInfo.adults, min: 1)
                PassengerStepper(label: "Children", subtitle: "Ages 2-11", count: $passengerInfo.children)
                PassengerStepper(label: "Infants", subtitle: "Under 2 years (lap seat)", count: $passengerInfo.infants, showInfoIcon: true)
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 5)
            .padding(.horizontal, 20)

            Spacer()

            // Confirm button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Confirm Selection")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(radius: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .padding()
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
    }
}

// Passenger Stepper with Info Tooltip for Infants
struct PassengerStepper: View {
    var label: String
    var subtitle: String?
    @Binding var count: Int
    var min: Int = 0
    var max: Int = 10
    var showInfoIcon: Bool = false

    @State private var showTooltip = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.title3)
                    .fontWeight(.semibold)

                if showInfoIcon {
                    Button(action: { showTooltip.toggle() }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                    }
                    .popover(isPresented: $showTooltip) {
                        Text("Infants must be under 2 years old at the time of travel. They must sit on an adult's lap unless a separate seat is booked.")
                            .font(.body)
                            .padding()
                            .frame(width: 250)
                    }
                }
            }

            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            HStack {
                Spacer()

                Button(action: {
                    if count > min { count -= 1 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(count > min ? .blue : .gray)
                }

                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)

                Button(action: {
                    if count < max { count += 1 }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(count < max ? .blue : .gray)
                }

                Spacer()
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 15)
    }
}

