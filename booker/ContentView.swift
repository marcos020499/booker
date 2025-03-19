import SwiftUI

extension View {
    @ViewBuilder func changeTextColor(_ color: Color) -> some View {
        if UITraitCollection.current.userInterfaceStyle == .light {
            self.colorInvert().colorMultiply(color)
        } else {
            self.colorMultiply(color)
        }
    }
}

struct ContentView: View {
    @State private var selectedFlightType: FlightType = .oneWay
    @State private var origin: Airport? = nil
    @State private var destination: Airport? = nil
    @State private var showAirportSheet: Bool = false
    @State private var selectingForOrigin: Bool = true
    
    @State private var departureDate: Date = Date()
    @State private var returnDate: Date = Date()
    
    @State private var passengerInfo = PassengerInfo()
    @State private var showPassengerSheet: Bool = false
    @State private var isLoading: Bool = false
    @State private var navigateToFlight: Bool = false

    var isFormComplete: Bool {
        guard origin != nil, destination != nil else { return false }
        if selectedFlightType == .roundTrip && returnDate <= departureDate { return false }
        if passengerInfo.adults < 1 { return false }
        return true
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    Text("Welcome to Flight Booker")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.top, 40)
                    
                    HStack(spacing: 0) {
                        ForEach(FlightType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .foregroundColor(selectedFlightType == type ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedFlightType == type ? Color("amBlue") : Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    selectedFlightType = type
                                }
                        }
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .padding()
                    
                    HStack(spacing: 10) {
                        AirportButton(label: "From", airport: origin, icon: "airplane.departure") {
                            selectingForOrigin = true
                            showAirportSheet = true
                        }
                        
                        Button(action: {
                            if let temp = origin {
                                origin = destination
                                destination = temp
                            }
                        }) {
                            Image(systemName: "arrow.left.arrow.right")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.gray)
                                .cornerRadius(8)
                        }
                        
                        AirportButton(label: "To", airport: destination, icon: "airplane.arrival") {
                            selectingForOrigin = false
                            showAirportSheet = true
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 10) {
                        DatePicker("Dep", selection: $departureDate, displayedComponents: .date)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.blue))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .colorScheme(.dark)
                        
                        if selectedFlightType == .roundTrip {
                            DatePicker("Ret", selection: $returnDate, in: departureDate..., displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.blue)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .colorScheme(.dark)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 80)
                    
                    Button(action: {
                        showPassengerSheet = true
                    }) {
                        HStack {
                            Text("Passengers: \(passengerInfo.adults) Adults, \(passengerInfo.children) Children, \(passengerInfo.infants) Infants")
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    NavigationLink(value: "flightView") {
                        Button(action: {
                            if isFormComplete {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    isLoading = false
                                    navigateToFlight = true
                                }
                            }
                        }) {
                            Text("Search Flights")
                                .font(.headline)
                                .foregroundColor(isFormComplete ? .white : .black)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isFormComplete ? Color("amRed") : Color.white)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .disabled(!isFormComplete)
                    }
                    
                    Spacer()
                }
            }
            .background(
                ZStack {
                    Image("defaultBackground")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                }
            )
            .sheet(isPresented: $showAirportSheet) {
                AirportSelectionView(airports: sampleAirports) { airport in
                    if selectingForOrigin {
                        origin = airport
                    } else {
                        destination = airport
                    }
                }
            }
            .sheet(isPresented: $showPassengerSheet) {
                PassengerSelectionView(passengerInfo: $passengerInfo)
            }
            .sheet(isPresented: $navigateToFlight) {
                FlightView()
            }
            .fullScreenCover(isPresented: $isLoading) {
                LoaderView()
            }

        }
    }
}

let sampleAirports = [
    Airport(name: "Los Angeles International", code: "LAX"),
    Airport(name: "John F. Kennedy International", code: "JFK"),
    Airport(name: "San Francisco International", code: "SFO"),
    Airport(name: "Chicago O'Hare International", code: "ORD"),
    Airport(name: "Dallas/Fort Worth International", code: "DFW"),
    Airport(name: "Miami International", code: "MIA"),
    Airport(name: "Denver International", code: "DEN"),
    Airport(name: "Seattle-Tacoma International", code: "SEA"),
    Airport(name: "Hartsfield-Jackson Atlanta International", code: "ATL"),
    Airport(name: "Boston Logan International", code: "BOS"),
    Airport(name: "Toronto Pearson International", code: "YYZ"),
    Airport(name: "Vancouver International", code: "YVR"),
    Airport(name: "London Heathrow", code: "LHR"),
    Airport(name: "Paris Charles de Gaulle", code: "CDG"),
    Airport(name: "Frankfurt International", code: "FRA"),
    Airport(name: "Tokyo Haneda", code: "HND"),
    Airport(name: "Dubai International", code: "DXB"),
    Airport(name: "Hong Kong International", code: "HKG"),
    Airport(name: "Singapore Changi", code: "SIN"),
    Airport(name: "Sydney Kingsford Smith", code: "SYD"),
    Airport(name: "Mexico City International", code: "MEX"),
    Airport(name: "São Paulo-Guarulhos International", code: "GRU"),
    Airport(name: "Buenos Aires Ezeiza International", code: "EZE"),
    Airport(name: "Madrid Barajas", code: "MAD")
]

