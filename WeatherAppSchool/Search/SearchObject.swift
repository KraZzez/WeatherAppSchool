//
//  SearchObject.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-15.
//
// Inspired by https://stackoverflow.com/questions/33380711/how-to-implement-auto-complete-for-address-using-apple-map-kit/67131376#67131376

import SwiftUI
import MapKit

struct SearchObject: View {
    @StateObject private var mapSearch = MapSearch()
    @ObservedObject var viewModel: DetailViewModel
    @StateObject var savedLocations = SavedLocationsViewModel()
    @Binding var hasPressedSearchedLocation: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Address", text: $mapSearch.searchTerm)
                }
                Section {
                    ForEach(mapSearch.locationResults, id: \.self) { location in
                        Button(action: {
                            hasPressedSearchedLocation = true
                            viewModel.reconcileLocation(location: location)
                            
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(location.title)
                                        .foregroundColor(.black)
                                    Text(location.subtitle)
                                        .font(.system(.caption))
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Button {
                                    // Add to favorite with app storage
                                } label: {
                                    Image(systemName: "star")
                                        .foregroundColor(.black)
                                }
                            }
                        })
                    }
                }
            }.navigationTitle(Text("Address search"))
                .onChange(of: viewModel.cityObject) { newValue in
                    dismiss()
                }
        }
    }
}

struct SearchObject_Previews: PreviewProvider {
    @State static var viewModel = DetailViewModel()
    @State static var hasPressedSearchedLocation = Bool()
    static var previews: some View {
        SearchObject(viewModel: viewModel, hasPressedSearchedLocation: $hasPressedSearchedLocation)
        
    }
}
