//
//  WeatherButton.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-07.
//

import SwiftUI

struct WeatherButton: View {
    
    var icon: String
    var textColor: Color
    var backgroundColor: Color
    var isNight: Bool
    
    var body: some View {
        Text(icon)
            .frame(width: 40, height: 40)
            .background(backgroundColor)
            .foregroundColor(textColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(8)
    }
}
