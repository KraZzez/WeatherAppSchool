//
//  GameModel.swift
//  Weather
//
//  Created by Ludvig Krantzén on 2022-11-07.
//

import Foundation
import Combine

class GameModel: ObservableObject{
    
    private var urlString = "https://api.open-meteo.com/v1/forecast?latitude=22.22&longitude=12.22&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&timezone=auto"
    private var cancellable: Cancellable?
    private let jsonDecoder = JSONDecoder()
    
    
    func changeLocation(lat: Double, lon: Double) -> Void {
        urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&timezone=auto"
        loadData()
    }
    
    var timeToday: String {
        return time?.first ?? ""
    }
    var tempToday: Int {
        return Int(temperature ?? 0)
    }
    
    var avgTemp: [Int] {
        var i = 0
        var tempResult = Array(repeating: 0, count: 7)
        
        while (i < temperature2MMax?.count ?? 0) {
            
            if let tempMax = temperature2MMax?[i]{
                if let tempMin = temperature2MMin?[i]{
                    tempResult[i] = (Int(tempMax + tempMin) / 2)
                }
            }
            i += 1
        }
        return tempResult
    }
    
    var dateArray: [Date] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy/MM/dd"
        var daysDates = [Date]()
        var i = 0
        if let dateStrings: [String] = time {
            while (i < dateStrings.count){
                let dateIterator = dateStrings[i]
                let newDate = dateFormatter.date(from: dateIterator)
                
                daysDates.append(newDate!)
                i += 1
            }
        }
        return daysDates
    }
    
    var dayNamesArray: [String] {
        let dates = dateArray
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        var dayNames: [String] = []
        
        for date in dates {
            let nameOfDay: String = dateFormatter.string(from: date)
            dayNames.append(nameOfDay)
        }
        return dayNames
    }
    
    @Published var weather: WeatherData?
    var longitude: Double?
    var time: [String]?
    var temperature: Double?
    var temperature2MMax: [Float]?
    var temperature2MMin: [Float]?
    var cityName: String?
    
    init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func loadData(){
        guard let url = URL(string: urlString) else{
            return
        }
        cancellable = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap{ element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode < 400 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: WeatherData.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] data in
                self?.weather = data
                self?.longitude = data.longitude
                self?.time = data.daily.time
                self?.temperature = data.currentWeather.temperature
                self?.temperature2MMax = data.daily.temperature2MMax
                self?.temperature2MMin = data.daily.temperature2MMin
            })
    }
    
}

