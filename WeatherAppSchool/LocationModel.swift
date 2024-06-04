//
//  LocationModel.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2023-01-11.
//

import Foundation
import SwiftUI

struct LocationModel: Identifiable, Codable, Equatable {
    let id: String
    let cityName: String
    let lat: Double
    let lon: Double
    
    init(id: String = UUID().uuidString, cityName: String, lat: Double, lon: Double) {
        self.id = id
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
    }
}
