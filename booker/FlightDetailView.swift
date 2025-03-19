import SwiftUI

struct FlightDetailView: View {
    let flight: Flight?
    @State private var isSeatMapPresented = false
    @State private var selectedSeat: String? // Stores the selected seat
    @State private var animatedProgress: Double = 0.0 // Animated flight progress
    
    var body: some View {
        VStack(spacing: 20) {
            if let flight = flight {
                VStack(spacing: 12) {
                    Text("\(flight.departureAirport) → \(flight.arrivalAirport)")
                        .font(.largeTitle)
                        .bold()
                        .transition(.slide)
                        .id(flight.flightNumber)
                    
                    Text("\(flight.airline) • Flight \(flight.flightNumber)")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .opacity(0.8)
                }
                .padding()
                .padding(.horizontal)

                // Flight Details
                VStack(spacing: 8) {
                    flightDetailRow(title: "Departure", value: flight.departureDateTime.formatted(), icon: "airplane.departure")
                    flightDetailRow(title: "Arrival", value: flight.arrivalDateTime.formatted(), icon: "airplane.arrival")
                    flightDetailRow(title: "Duration", value: "\(flight.duration) hrs", icon: "clock")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.1)))
                .padding(.horizontal)

                // Baggage & Seat Selection
                VStack(spacing: 8) {
                    flightDetailRow(title: "Class", value: flight.seatClass.rawValue, icon: "person.fill")
                    flightDetailRow(title: "Baggage", value: "\(flight.baggageAllowance) kg included", icon: "suitcase.fill")

                    if let seat = selectedSeat {
                        flightDetailRow(title: "Seat", value: seat, icon: "chair.fill")
                            .transition(.opacity)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.orange.opacity(0.1)))
                .padding(.horizontal)

                // Flight Progress
                VStack {
                    Text("Flight Progress")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    ProgressView(value: animatedProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(width: 200)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                animatedProgress = flight.progress
                            }
                        }
                }
                .padding(.vertical)

                // Fare and Price
                VStack {
                    Text("Fare Family: \(flight.fareFamily)")
                        .font(.headline)
                    
                    Text("Price: \(flight.currency) \(String(format: "%.2f", flight.price))")
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                        .scaleEffect(1.1)
                        .animation(.easeInOut(duration: 0.5), value: flight.price)
                }
                .padding(.bottom, 10)

                // Seat Selection Button
                Button(action: {
                    isSeatMapPresented.toggle()
                }) {
                    Text(selectedSeat != nil ? "Change Seat" : "Select Your Seat")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("amRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .sheet(isPresented: $isSeatMapPresented) {
                    SeatSelectionView(fareFamily: flight.fareFamily, selectedSeat: $selectedSeat)
                }

                // Continue to Payment Button
                NavigationLink(destination: PaymentView(flight: flight)) {
                    Text("Continue to Pay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("amBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            } else {
                Text("No Flight Selected")
                    .font(.title)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
        .padding()
        .navigationTitle("Flight Details")
        .onAppear {
            withAnimation(.spring()) {
                animatedProgress = flight?.progress ?? 0.0
            }
        }
    }
    
    func flightDetailRow(title: String, value: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

