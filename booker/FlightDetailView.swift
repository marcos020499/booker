//
//  FlightDetailView.swift
//  booker
//
//  Created by sw on 13/03/25.
//


import SwiftUI

struct FlightDetailView: View {
    let flight: Flight?
    
    var body: some View {
        VStack(spacing: 20) {
            if let flight = flight {
                Text("\(flight.departureAirport) → \(flight.arrivalAirport)")
                    .font(.largeTitle)
                    .bold()
                
                Text("Departure: \(flight.departureDateTime)")
                    .font(.title2)
                Text("Arrival: \(flight.arrivalDateTime)")
                    .font(.title2)
                Text("Fare Family: \(flight.fareFamily)")
                    .font(.headline)
                Text("Price: \(flight.currency) \(String(format: "%.2f", flight.price))")
                    .font(.title)
                    .bold()
                    .foregroundColor(.green)
                
                NavigationLink(destination: PaymentView(flight: flight)) {
                    Text("Continue to Pay")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                Text("No Flight Selected")
                    .font(.title)
            }
        }
        .padding()
        .navigationTitle("Flight Details")
    }
}
