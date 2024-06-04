//
//  DetailViewModel.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-16.
//
// Inspired by https://stackoverflow.com/questions/33380711/how-to-implement-auto-complete-for-address-using-apple-map-kit/67131376#67131376

import Foundation
import MapKit
import SwiftUI

class DetailViewModel : ObservableObject {
    @Published var cityObject: CityObject = CityObject(cityName: "Unknown", cityCoordinates: (CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)))
    
    
    func reconcileLocation(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error == nil, let coordinate = response?.mapItems.first?.placemark.coordinate {
                self.cityObject = CityObject(cityName: location.title, cityCoordinates: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
            }
        }
    }
}
