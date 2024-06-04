//
//  SavedLocationsViewModel.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2023-01-11.
//

import Foundation

class SavedLocationsViewModel: ObservableObject {
    @Published var savedLocations: [LocationModel] = [] {
        didSet {
            saveLocation()
        }
    }
    let locationKey: String = "location_list"
    
    init() {
        getLocations()
    }
    
    func getLocations() {
       /* let newItems = [
            LocationModel(cityName: "Jönköping", lat: 22, lon: 32),
            LocationModel(cityName: "Kinna", lat: 102, lon: 222),
            LocationModel(cityName: "Örby", lat: 60, lon: 14)
        ]
        savedLocations.append(contentsOf: newItems) */
        guard
            let data = UserDefaults.standard.data(forKey: locationKey),
            let locations = try? JSONDecoder().decode([LocationModel].self, from: data)
        else { return }
        
        self.savedLocations = locations
    }
    
    func deleteLocation(at indexSet: IndexSet) {
        savedLocations.remove(atOffsets: indexSet)
    }
    
    func addLocation(cityName: String, lat: Double, lon: Double) {
        let newLocation = LocationModel(cityName: cityName, lat: lat, lon: lon)
        savedLocations.append(newLocation)
    }
    
    func saveLocation() {
        if let encodedData = try? JSONEncoder().encode(savedLocations) {
            UserDefaults.standard.set(encodedData, forKey: locationKey)
        }
    }
    
    func checkIfSaved(currentCityName: String) -> Bool {
        for location in savedLocations {
            if location.cityName == currentCityName {
                return true
            }
        }
        return false
    }
}
