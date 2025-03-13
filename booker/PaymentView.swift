//
//  PaymentView.swift
//  booker
//
//  Created by sw on 13/03/25.
//

import SwiftUI


struct PaymentView: View {
    let flight: Flight
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment for \(flight.departureAirport) → \(flight.arrivalAirport)")
                .font(.headline)
            
            Text("Total Price: \(flight.currency) \(String(format: "%.2f", flight.price))")
                .font(.title2)
                .bold()
                .foregroundColor(.green)
            
            TextField("Card Number", text: $cardNumber)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            TextField("Expiry Date (MM/YY)", text: $expiryDate)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            SecureField("CVV", text: $cvv)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button(action: {
                // Handle payment processing
            }) {
                Text("Pay Now")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Payment")
    }
}
