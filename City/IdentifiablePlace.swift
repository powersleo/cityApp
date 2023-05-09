//
//  IdentifiablePlace.swift
//  City
//
//  Created by Leo Powers on 5/8/23.
//

import Foundation
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    let name: String
    init(id: UUID = UUID(), lat: Double, long: Double, name:String) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
        self.name = name
    }
}
