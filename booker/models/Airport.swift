//
//  Airport.swift
//  booker
//
//  Created by sw on 12/03/25.
//

import Foundation


struct Airport: Identifiable {
    let id = UUID()
    let name: String
    let code: String
}

enum FlightType: String, CaseIterable, Identifiable {
    case oneWay = "One Way"
    case roundTrip = "Round Trip"
    
    var id: String { self.rawValue }
}


struct PassengerInfo {
    var adults: Int = 1
    var children: Int = 0
    var infants: Int = 0
}
