import SwiftUI
import Sliders

struct Flight: Identifiable {
    let id = UUID()
    let departureAirport: String
    let arrivalAirport: String
    let departureDateTime: String
    let arrivalDateTime: String
    let price: Double
    let currency: String
    let fareFamily: String
    let duration: Int // Duration in minutes
}

struct FlightView: View {
    @State private var selectedFareFamily: String = "ECONOMY"
    @State private var selectedFlight: Flight? = nil
    @State private var navigateToDetails = false
    
    // Filter States
    @State private var showFilters = false
    @State private var selectedTimeRange: String = "Any"
    @State private var priceRange: ClosedRange<Double> = 3000...10000
    @State private var durationRange: ClosedRange<Double> = 60...300

    let flights: [Flight] = [
        Flight(departureAirport: "MEX", arrivalAirport: "ACA", departureDateTime: "16:25", arrivalDateTime: "17:37", price: 4169.0, currency: "MXN", fareFamily: "ECONOMY", duration: 72),
        Flight(departureAirport: "MEX", arrivalAirport: "CUN", departureDateTime: "09:15", arrivalDateTime: "12:40", price: 3899.0, currency: "MXN", fareFamily: "ECONOMY", duration: 205),
        Flight(departureAirport: "MEX", arrivalAirport: "ACA", departureDateTime: "07:30", arrivalDateTime: "08:42", price: 5432.0, currency: "MXN", fareFamily: "AM_PLUS", duration: 72),
        Flight(departureAirport: "MEX", arrivalAirport: "CUN", departureDateTime: "11:50", arrivalDateTime: "15:10", price: 6299.0, currency: "MXN", fareFamily: "AM_PLUS", duration: 200)
    ]

    var filteredFlights: [Flight] {
        flights.filter { flight in
            flight.fareFamily == selectedFareFamily &&
            priceRange.contains(flight.price) &&
            durationRange.contains(Double(flight.duration)) &&
            isTimeInRange(flight.departureDateTime)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // **Cabin Selection Buttons**
                HStack(spacing: 10) {
                    CabinButton(label: "ECONOMY", color: .brown, isSelected: selectedFareFamily == "ECONOMY") {
                        selectedFareFamily = "ECONOMY"
                    }
                    CabinButton(label: "AM_PLUS", color: .blue, isSelected: selectedFareFamily == "AM_PLUS") {
                        selectedFareFamily = "AM_PLUS"
                    }
                    CabinButton(label: "PREMIER", color: .purple, isSelected: selectedFareFamily == "PREMIER") {
                        selectedFareFamily = "PREMIER"
                    }
                }
                .padding(.horizontal)

                // **Filter Toggle Button**
                Button(action: { showFilters.toggle() }) {
                    HStack {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.title2)
                        Text("Filters")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.blue)
                    .padding()
                }

                // **Filters Section (Toggles Visibility)**
                if showFilters {
                    VStack(alignment: .leading, spacing: 10) {
                        // **Time Range Filter**
                        Text("Filter by Time")
                            .font(.headline)
                        Picker("Time Range", selection: $selectedTimeRange) {
                            Text("Any").tag("Any")
                            Text("Morning (00:00 - 12:00)").tag("Morning")
                            Text("Afternoon (12:00 - 18:00)").tag("Afternoon")
                            Text("Evening (18:00 - 23:59)").tag("Evening")
                        }
                        .pickerStyle(.segmented)

                        // **Price Range Filter**
                        Text("Filter by Price: \(Int(priceRange.lowerBound)) - \(Int(priceRange.upperBound)) MXN")
                            .font(.headline)
                        RangeSlider(range: $priceRange, in: 3000...10000, step: 100)
                            .padding()
                            .accentColor(.blue)

                        // **Duration Filter**
                        Text("Filter by Duration: \(Int(durationRange.lowerBound)) - \(Int(durationRange.upperBound)) min")
                            .font(.headline)
                        RangeSlider(range: $durationRange, in: 60...300, step: 5)
                            .padding()
                            .accentColor(.red)

                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .padding(.horizontal)
                    .transition(.slide) // Smooth transition
                }

                // **Flight List**
                List(filteredFlights) { flight in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(flight.departureAirport) → \(flight.arrivalAirport)")
                            .font(.headline)
                        Text("Departure: \(flight.departureDateTime) | Arrival: \(flight.arrivalDateTime)")
                            .font(.subheadline)
                        Text("Duration: \(flight.duration) min")
                            .font(.subheadline)
                        Text("Price: \(flight.currency) \(String(format: "%.2f", flight.price))")
                            .font(.subheadline)
                            .bold()
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedFlight?.id == flight.id ? Color.green.opacity(0.3) : Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        selectedFlight = flight
                        navigateToDetails = true
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Flights")

                // Navigate to Flight Details
                NavigationLink("", destination: FlightDetailView(flight: selectedFlight), isActive: $navigateToDetails)
                    .hidden()
            }
        }
    }

    // Helper Function to Filter by Time
    func isTimeInRange(_ time: String) -> Bool {
        guard selectedTimeRange != "Any" else { return true }
        let hour = Int(time.prefix(2)) ?? 0
        switch selectedTimeRange {
        case "Morning": return (0...11).contains(hour)
        case "Afternoon": return (12...17).contains(hour)
        case "Evening": return (18...23).contains(hour)
        default: return true
        }
    }
}

// **Cabin Selection Button Component**
struct CabinButton: View {
    let label: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .foregroundColor(isSelected ? .white : color)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ? color : Color.clear)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: isSelected ? 0 : 2)
                )
        }
        .frame(height: 50)
    }
}
