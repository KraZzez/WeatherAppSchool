//
//  WeatherData.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-17.
//

import Foundation

struct WeatherData: Decodable {
    let longitude: Double
    let latitude: Double
    struct CurrentWeather: Decodable {
        let temperature: Double
        let time: String
    }
    let currentWeather: CurrentWeather
    struct Daily: Decodable {
        let time: [String]
        let temperature2MMax: [Float]
        let temperature2MMin: [Float]
    }
    let daily: Daily
}
