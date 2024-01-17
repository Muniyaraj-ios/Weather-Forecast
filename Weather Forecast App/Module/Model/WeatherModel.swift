//
//  WeatherModel.swift
//  Weather Forecast App
//
//  Created by Apple on 12/01/24.
//

import Foundation

struct WeatherData: Codable,BaseSwiftJson {
    let city: City
    let cnt: Int
    let cod: String
    var list: [WeatherDetails]
    let message: String
    init(_ dict: Parameters) {
        self.city = City(dict["city"] as? [String: Any] ?? [:])
        self.cnt = dict["cnt"] as? Int ?? 0
        
        if let listArray = dict["list"] as? [[String: Any]] {
            self.list = listArray.map { WeatherDetails($0) }
        } else {
            self.list = []
        }
        
        self.cod = dict["cod"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
    }
}
extension WeatherData{
    struct City: Codable,BaseSwiftJson {
        let coord: WeatherResponse.Coord
        let country: String
        let id: Int
        let name: String
        let population: Int
        let sunrise: Int
        let sunset: Int
        let timezone: Int
        init(_ dict: Parameters) {
            self.coord = WeatherResponse.Coord(dict["coord"] as? [String: Any] ?? [:])
            self.country = dict["country"] as? String ?? ""
            self.id = dict["id"] as? Int ?? 0
            self.name = dict["name"] as? String ?? ""
            self.population = dict["population"] as? Int ?? 0
            self.sunrise = dict["sunrise"] as? Int ?? 0
            self.sunset = dict["sunset"] as? Int ?? 0
            self.timezone = dict["timezone"] as? Int ?? 0
        }
    }
    struct WeatherDetails: Codable,BaseSwiftJson,Hashable {
        static func == (lhs: WeatherData.WeatherDetails, rhs: WeatherData.WeatherDetails) -> Bool {
            return lhs.id == rhs.id
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        var id = UUID()
        let clouds: WeatherResponse.Clouds
        let dt: Int
        let dt_txt: String
        let main: WeatherResponse.Main
        let pop: Int
        let sys: Sys
        let visibility: Int
        let weather: [WeatherResponse.Weather]
        let wind: WeatherResponse.Wind
        init(_ dict: Parameters) {
            self.clouds = WeatherResponse.Clouds(dict["clouds"] as? [String: Any] ?? [:])
            self.dt = dict["dt"] as? Int ?? 0
            self.dt_txt = dict["dt_txt"] as? String ?? ""
            self.main = WeatherResponse.Main(dict["main"] as? [String: Any] ?? [:])
            self.pop = dict["pop"] as? Int ?? 0
            self.sys = Sys(dict["sys"] as? [String: Any] ?? [:])
            self.visibility = dict["visibility"] as? Int ?? 0
            if let weatherArray = dict["weather"] as? [[String: Any]] {
                self.weather = weatherArray.map { WeatherResponse.Weather($0) }
            } else {
                self.weather = []
            }
            
            self.wind = WeatherResponse.Wind(dict["wind"] as? [String: Any] ?? [:])
        }
    }
    struct Sys: Codable,BaseSwiftJson {
        let pod: String
        init(_ dict: Parameters) {
            self.pod = dict["pod"] as? String ?? ""
        }
    }
    struct Wind: Codable,BaseSwiftJson {
        let deg: Int
        let gust: String
        let speed: String
        init(_ dict: Parameters) {
            self.deg = dict["deg"] as? Int ?? 0
            self.gust = dict["gust"] as? String ?? ""
            self.speed = dict["speed"] as? String ?? ""
        }
    }
}


struct WeatherResponse: Codable, BaseSwiftJson {
    let base: String
    let clouds: WeatherResponse.Clouds
    let cod: Int
    let message: String
    let coord: Coord
    let dt: Int
    let id: Int
    let main: WeatherResponse.Main
    let name: String
    let sys: WeatherResponse.Sys
    let timezone: Int
    let visibility: Double
    let weather: [WeatherResponse.Weather]
    let wind: WeatherResponse.Wind
    
    init(_ dict: [String: Any]) {
        self.base = dict["base"] as? String ?? ""
        self.message = dict["message"] as? String ?? ""
        self.cod = dict["cod"] as? Int ?? 0
        self.dt = dict["dt"] as? Int ?? 0
        self.id = dict["id"] as? Int ?? 0
        self.name = dict["name"] as? String ?? ""
        self.timezone = dict["timezone"] as? Int ?? 0
        self.visibility = (dict["visibility"] as? Double ?? 0.0).roundToDecimal(1)
        
        // Converting nested structures
        self.clouds = WeatherResponse.Clouds(dict["clouds"] as? [String: Any] ?? [:])
        self.coord = WeatherResponse.Coord(dict["coord"] as? [String: Any] ?? [:])
        self.main = WeatherResponse.Main(dict["main"] as? [String: Any] ?? [:])
        self.sys = WeatherResponse.Sys(dict["sys"] as? [String: Any] ?? [:])
        
        if let weatherArray = dict["weather"] as? [[String: Any]] {
            self.weather = weatherArray.map { WeatherResponse.Weather($0) }
        } else {
            self.weather = []
        }
        
        self.wind = WeatherResponse.Wind(dict["wind"] as? [String: Any] ?? [:])
    }
}

extension WeatherResponse {
    struct Clouds: Codable {
        let all: Int
        
        init(_ dict: [String: Any]) {
            self.all = dict["all"] as? Int ?? 0
        }
    }
    
    struct Coord: Codable {
        let lat: Double
        let lon: Double
        
        init(_ dict: [String: Any]) {
            self.lat = dict["lat"] as? Double ?? 0.0
            self.lon = dict["lon"] as? Double ?? 0.0
        }
    }
    
    struct Main: Codable {
        let feelsLike: Double
        let humidity: Int
        let pressure: Int
        let temp: Double
        let tempMax: Double
        let tempMin: Double
        
        init(_ dict: [String: Any]) {
            self.feelsLike = (dict["feels_like"] as? Double ?? 0.0).roundToDecimal(1)
            self.humidity = dict["humidity"] as? Int ?? 0
            self.pressure = dict["pressure"] as? Int ?? 0
            self.temp = (dict["temp"] as? Double ?? 0.0).roundToDecimal(1)
            self.tempMax = (dict["temp_max"] as? Double ?? 0.0).roundToDecimal(1)
            self.tempMin = (dict["temp_min"] as? Double ?? 0.0).roundToDecimal(1)
        }
    }
    
    struct Sys: Codable {
        let country: String
        let sunrise: Int
        let sunset: Int
        
        init(_ dict: [String: Any]) {
            self.country = dict["country"] as? String ?? ""
            self.sunrise = dict["sunrise"] as? Int ?? 0
            self.sunset = dict["sunset"] as? Int ?? 0
        }
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
        let id: Int
        let main: String
        
        init(_ dict: [String: Any]) {
            self.description = dict["description"] as? String ?? ""
            self.icon = dict["icon"] as? String ?? ""
            self.id = dict["id"] as? Int ?? 0
            self.main = dict["main"] as? String ?? ""
        }
    }
    
    struct Wind: Codable {
        let deg: Int
        let gust: Double
        let speed: Double
        
        init(_ dict: [String: Any]) {
            self.deg = dict["deg"] as? Int ?? 0
            self.gust = (dict["gust"] as? Double ?? 0.0).roundToDecimal(1)
            self.speed = (dict["speed"] as? Double ?? 0.0).roundToDecimal(2)
        }
    }
}
