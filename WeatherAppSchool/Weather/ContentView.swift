//
//  ContentView.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-07.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
import MapKit
import Combine

struct ContentView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var gameModel = GameModel()
    @State private var isNight = false
    @State private var time: [String] = []
    @State var locationToken: Cancellable?
    @StateObject var viewModel = DetailViewModel()
    @State var hasPressedSearchedLocation = false
    @State private var showFavoriteListSheet = false
    @StateObject var locationViewModel = SavedLocationsViewModel()
    @State var isFavorited = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(isNight: $isNight)
                VStack {
                    HStack {
                        VStack {
                            Text("\(viewModel.cityObject.cityName)")
                                .font(.system(size: 24))
                            Text("\(gameModel.tempToday)°")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 150, weight: .medium))
                        Text("Cloudy Today")
                            .frame(alignment: .bottom)
                            .rotationEffect(.degrees(-90))
                            .font(.system(size: 18, weight: .bold))
                            .padding(.trailing, -30)
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    VStack {
                        if locationViewModel.checkIfSaved(currentCityName: viewModel.cityObject.cityName) {
                            Button {
                                locationViewModel.savedLocations.remove(at: locationViewModel.savedLocations.firstIndex{$0.cityName == viewModel.cityObject.cityName} ?? 0)
                            } label: {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.black)
                            }
                        }
                        else {
                            Button {
                                locationViewModel.addLocation(cityName: viewModel.cityObject.cityName, lat: viewModel.cityObject.cityCoordinates.latitude, lon: viewModel.cityObject.cityCoordinates.longitude)
                            } label: {
                                Image(systemName: "star")
                                    .foregroundColor(.black)
                            }
                        }
                        HStack {
                            NavigationLink(destination: SearchObject(viewModel: viewModel, hasPressedSearchedLocation: $hasPressedSearchedLocation)) {
                                Image(systemName: "location.magnifyingglass")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(11)
                                    .background(.black)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            
                            
                            Button {
                                isNight.toggle()
                            } label: {
                                Image(systemName: "moon.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(11)
                                    .background(.black)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                            
                            LocationButton {
                                locationManager.requestLocation()
                                
                                locationToken = locationManager.$location.sink { location in
                                    if let location {
                                        gameModel.changeLocation(lat: location.latitude, lon: location.longitude)
                                        viewModel.cityObject.cityName = "Your Location"
                                    }
                                }
                                
                            }
                            .labelStyle(.iconOnly)
                            .tint(.black)
                            .cornerRadius(10)
                            .symbolVariant(.fill)
                            .foregroundColor(.white)
                            
                            Button {
                                showFavoriteListSheet.toggle()
                            } label: {
                                Image(systemName: "moon.fill")
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(11)
                                    .background(.black)
                                    .cornerRadius(10)
                                    .foregroundColor(.white)
                            }
                        }
                    }

                    HStack(spacing: 8) {
                        let dayArray = gameModel.dayNamesArray
                        if dayArray.isEmpty {
                            Text("Loading")
                        } else {
                            WeatherDayView(dayOfWeek: dayArray[0], imageName: "cloud.sun.fill", temperature: gameModel.avgTemp[0])
                            WeatherDayView(dayOfWeek: dayArray[1], imageName: "sun.max.fill", temperature: gameModel.avgTemp[1])
                            WeatherDayView(dayOfWeek: dayArray[2], imageName: "cloud.sun.fill", temperature: gameModel.avgTemp[2])
                            WeatherDayView(dayOfWeek: dayArray[3], imageName: "cloud.sun.fill", temperature: gameModel.avgTemp[3])
                            WeatherDayView(dayOfWeek: dayArray[4], imageName: "sun.max.fill", temperature: gameModel.avgTemp[4])
                            WeatherDayView(dayOfWeek: dayArray[5], imageName: "cloud.sun.fill", temperature: gameModel.avgTemp[5])
                            WeatherDayView(dayOfWeek: dayArray[6], imageName: "wind.snow", temperature: gameModel.avgTemp[6])
                        }
                    }
                    .frame(width: 355, height: 170)
                    .background(.white.opacity(0.3))
                    .cornerRadius(10)
                }
                .sheet(isPresented: $showFavoriteListSheet, onDismiss: {
                    gameModel.changeLocation(lat: viewModel.cityObject.cityCoordinates.latitude, lon: viewModel.cityObject.cityCoordinates.longitude)
                    gameModel.loadData()
                }, content: {
                    FavoritesView(viewModel: self.viewModel, locationViewModel: self.locationViewModel)
                })
            }
            .onAppear{
                if hasPressedSearchedLocation {
                    gameModel.changeLocation(lat: viewModel.cityObject.cityCoordinates.latitude, lon: viewModel.cityObject.cityCoordinates.longitude)
                    gameModel.loadData()
                }
                else {
                    gameModel.loadData()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
