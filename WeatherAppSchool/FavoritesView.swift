//
//  FavoritesView.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2023-01-11.
//

import SwiftUI
import MapKit
import Combine
import CoreLocation

struct FavoritesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var gameModel = GameModel()
    @ObservedObject var viewModel: DetailViewModel
    @ObservedObject var locationViewModel: SavedLocationsViewModel
    
    var body: some View {
        List {
            ForEach(locationViewModel.savedLocations) { location in
                Button {
                    viewModel.cityObject.cityName = location.cityName
                    viewModel.cityObject.cityCoordinates.latitude = location.lat
                    viewModel.cityObject.cityCoordinates.longitude = location.lon
                    dismiss()
                } label: {
                    VStack {
                        Text(location.cityName)
                        Text("\(location.lat)")
                        Text("\(location.lon)")
                    }
                }
            }
            .onDelete(perform: locationViewModel.deleteLocation)
        }
    }
}
