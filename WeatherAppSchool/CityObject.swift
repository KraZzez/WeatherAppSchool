//
//  CityObject.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-17.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import SwiftUI
import Contacts

struct CityObject: Identifiable, Equatable {
    static func == (lhs: CityObject, rhs: CityObject) -> Bool {
        lhs.id == rhs.id
    }
    let id: String
    var cityName: String
    var cityCoordinates: (CLLocationCoordinate2D)
    
    init(id: String = UUID().uuidString, cityName: String, cityCoordinates: (CLLocationCoordinate2D)) {
        self.id = id
        self.cityName = cityName
        self.cityCoordinates = cityCoordinates
    }
}
