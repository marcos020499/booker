import SwiftUI
import Sliders

struct Flight: Identifiable {
    let id = UUID()
    let departureAirport: String
    let arrivalAirport: String
    let departureDateTime: Date
    let arrivalDateTime: Date
    let airline: String
    let flightNumber: String
    let duration: Int // Duration in minutes
    let seatClass: SeatClass
    let baggageAllowance: Int // In kg
    let fareFamily: String
    let price: Double
    let currency: String
    let progress: Double // Progress of the flight (0.0 - 1.0)
}

enum SeatClass: String {
    case economy = "Economy"
    case business = "Business"
    case firstClass = "First Class"
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
        Flight(departureAirport: "MEX", arrivalAirport: "ACA",
               departureDateTime: Date(), arrivalDateTime: Calendar.current.date(byAdding: .minute, value: 72, to: Date())!,
               airline: "Aeroméxico", flightNumber: "AM243", duration: 72,
               seatClass: .economy, baggageAllowance: 15,
               fareFamily: "ECONOMY", price: 4169.0, currency: "MXN", progress: 0.2),
        
        Flight(departureAirport: "MEX", arrivalAirport: "CUN",
               departureDateTime: Date(), arrivalDateTime: Calendar.current.date(byAdding: .minute, value: 205, to: Date())!,
               airline: "Volaris", flightNumber: "VO326", duration: 205,
               seatClass: .economy, baggageAllowance: 20,
               fareFamily: "ECONOMY", price: 3899.0, currency: "MXN", progress: 0.5),
        
        Flight(departureAirport: "MEX", arrivalAirport: "ACA",
               departureDateTime: Date(), arrivalDateTime: Calendar.current.date(byAdding: .minute, value: 72, to: Date())!,
               airline: "Interjet", flightNumber: "IJ102", duration: 72,
               seatClass: .business, baggageAllowance: 25,
               fareFamily: "AM_PLUS", price: 5432.0, currency: "MXN", progress: 0.3),
        
        Flight(departureAirport: "MEX", arrivalAirport: "CUN",
               departureDateTime: Date(), arrivalDateTime: Calendar.current.date(byAdding: .minute, value: 200, to: Date())!,
               airline: "Aeroméxico", flightNumber: "AM458", duration: 200,
               seatClass: .business, baggageAllowance: 30,
               fareFamily: "AM_PLUS", price: 6299.0, currency: "MXN", progress: 0.7)
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
                if showFilters {
                    VStack(alignment: .leading, spacing: 10) {
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
                    .transition(.slide)
                }

                List(filteredFlights) { flight in
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(flight.departureAirport) → \(flight.arrivalAirport)")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("Duration: \(flight.duration) min")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text("Price: \(flight.currency) \(String(format: "%.2f", flight.price))")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                        }

                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(flight.airline)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Text(flight.flightNumber)
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        flight.fareFamily == "ECONOMY" ? Color.brown.opacity(0.7) :
                        flight.fareFamily == "AM_PLUS" ? Color.blue.opacity(0.7) :
                        flight.fareFamily == "PREMIER" ? Color.purple.opacity(0.7) :
                        Color.purple.opacity(0.7)
                    )
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
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Flights")
                            .font(.headline) // Customize font if needed
                            .foregroundColor(.white) // Change title color
                    }
                }
                NavigationLink("", destination: FlightDetailView(flight: selectedFlight), isActive: $navigateToDetails)
                    .hidden()
            }
        }
    }

    func isTimeInRange(_ time: Date) -> Bool {
        guard selectedTimeRange != "Any" else { return true }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        
        let timeRanges: [String: ClosedRange<Int>] = [
            "Morning": 6...11,
            "Afternoon": 12...17,
            "Evening": 18...23,
            "Night": 0...5
        ]
        
        return timeRanges[selectedTimeRange]?.contains(hour) ?? true
    }
}

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
