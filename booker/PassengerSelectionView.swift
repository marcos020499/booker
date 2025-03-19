import SwiftUI

struct PassengerSelectionView: View {
    @Binding var passengerInfo: PassengerInfo
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 30) {
            Text("Passenger Selection")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 30)
            
            Text("Select the number of passengers for your trip.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

            VStack(spacing: 15) {
                PassengerStepper(label: "Adults", subtitle: "Ages 12 and above", count: $passengerInfo.adults, min: 1)
                PassengerStepper(label: "Children", subtitle: "Ages 2-11", count: $passengerInfo.children)
                PassengerStepper(label: "Infants", subtitle: "Under 2 years (lap seat)", count: $passengerInfo.infants, showInfoIcon: true)
            }
            .padding(20)
            .background(Color("amBlue"))
            .cornerRadius(16)
            .shadow(radius: 5)
            .padding(.horizontal, 10)

            Spacer()

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
            .padding(.horizontal, 10)
            .padding(.bottom, 30)
        }
        .padding()
    }
}

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
                    .foregroundColor(.white)

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
                    .foregroundColor(Color("amGray"))
            }

            HStack {
                Spacer()

                Button(action: {
                    if count > min { count -= 1 }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 40))
                        .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, count > min ? .blue : Color("amGray"))
                }

                Text("\(count)")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(width: 50, alignment: .center)
                    .foregroundColor(.white)

                Button(action: {
                    if count < max { count += 1 }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white, count < max ? .blue : Color("amGray"))
                }

                Spacer()
            }
            .padding(.top, 5)
        }
        .padding(.vertical, 15)
    }
}

