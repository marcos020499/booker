//
//  AirportSelectionView.swift
//  booker
//
//  Created by sw on 12/03/25.
//

import SwiftUICore
import SwiftUI


struct AirportSelectionView: View {
    let airports: [Airport]
    var onSelect: (Airport) -> Void
    
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var filteredAirports: [Airport] {
        searchText.isEmpty ? airports : airports.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.code.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredAirports) { airport in
                Button(action: {
                    onSelect(airport)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(airport.name).font(.headline)
                            .foregroundColor(Color("amBlue"))
                        Text(airport.code).font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Select Airport")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
