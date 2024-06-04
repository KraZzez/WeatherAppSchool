//
//  BackgroundView.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-17.
//

import SwiftUI

struct BackgroundView: View {
    
    @Binding var isNight: Bool
    
    var body: some View {
        if isNight {
            Image("back")
                .resizable()
                .ignoresSafeArea()
        }
        else {
            Image("night")
                .resizable()
                .ignoresSafeArea()
        }
    }
}
