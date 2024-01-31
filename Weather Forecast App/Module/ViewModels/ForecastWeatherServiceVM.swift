//
//  ForecastWeatherServiceVM.swift
//  Weather Forecast App
//
//  Created by Apple on 16/01/24.
//

import Foundation

class ForecastWeatherServiceVM: NSObject,ObservableObject{
    var unitType: UnitType = .metric
    @Published var weatherReqData: CurrentWeatherRequest = CurrentWeatherRequest()
    @Published var forecastReqData: ForecastWeatherRequest = ForecastWeatherRequest()
    
    let apiManager: APIManger? = APIManger()
    
    func getWeatherData(city name: String){
        self.weatherReqData.isLoading = true
        let endPoint: APIEndPoints = .currentCity(cityName: name, countryCode: "", units: .metric)
        guard let request = apiManager?.getURLRequest(endPoint: endPoint, method: .get, param: nil) else{return}
        apiManager?.getAllData(request) { (result: Results<WeatherResponse,Error>) in
            DispatchQueue.main.async {
                self.weatherReqData.isLoading = false
                switch result {
                    case .success(let weatherResponse):
                    if weatherResponse.cod == 200{
                        self.weatherReqData.isError = nil
                        self.weatherReqData.weatherData = weatherResponse
                    }else{
                        let error_desc = weatherResponse.cod == 404 ? "Search Result not found! '\(name)'" : "\(weatherResponse.message)"
                        self.weatherReqData.isError = NSError(domain: "com.weatherforecast.app", code: weatherResponse.cod, userInfo: [NSLocalizedDescriptionKey: error_desc,NSDebugDescriptionErrorKey: "Problem with Request"])
                    }
                    case .failure(let error):
                    self.weatherReqData.weatherData = nil
                    self.weatherReqData.isError = error
                    print("Error fetching weather data: \(error)")
               }
           }
        }
    }
    func getForecastFiveDayData(city name: String){
        self.forecastReqData.isLoading = true
        let endPoint: APIEndPoints = .forecastCity(cityName: name, Countrycode: "", units: .metric)
        guard let request = apiManager?.getURLRequest(endPoint: endPoint, method: .get, param: nil) else{return}
        apiManager?.getAllData(request) { (result: Results<WeatherData,Error>) in
            DispatchQueue.main.async {
                self.forecastReqData.isLoading = false
                switch result {
                    case .success(let weatherData):
                    print("weatherData cod : \(weatherData.cod)")
                    if weatherData.cod == "200"{
                        self.forecastReqData.isError = nil
                        self.forecastReqData.weatherData = weatherData
                        self.customizeListData(self.forecastReqData.weatherData?.list ?? [])
                    }else{
                        let error_desc = weatherData.cod == "404" ? "Search Result not found! '\(name)'\ncheck if the city name or zipcode is correct" : "\(weatherData.message)"
                        self.forecastReqData.isError = NSError(domain: "com.weatherforecast.app", code: Int(weatherData.cod) ?? 0, userInfo: [NSLocalizedDescriptionKey: error_desc,NSDebugDescriptionErrorKey: "Problem with Request"])
                    }
                    case .failure(let error):
                    self.forecastReqData.weatherData = nil
                    self.forecastReqData.listData = [:]
                    self.forecastReqData.currentListData = []
                    self.forecastReqData.isError = error
                    print("Error fetching weather data: \(error)")
               }
            }
        }
    }
    private func customizeListData(_ weathersList: [WeatherData.WeatherDetails]){
        forecastReqData.listData = [:]
        for (i,val) in weathersList.enumerated(){
            let dateForm = weathersList[i].dt_txt.formatDate(with: .dateMonYear)
            if forecastReqData.listData[dateForm] == nil{
                forecastReqData.listData[dateForm] = [val]
            }else{
                forecastReqData.listData[dateForm]?.append(val)
            }
        }
        sortDates()
    }
    private func sortDates() {
        let sortedDict  = forecastReqData.listData.sorted(by: { (entry1, entry2) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = DateFormats.dateMonYear.format
            if let date1 = dateFormatter.date(from: entry1.key),
               let date2 = dateFormatter.date(from: entry2.key) {
                return date1 < date2
            }
            return false
        })
        let orderedDict = Dictionary(uniqueKeysWithValues: sortedDict)
        forecastReqData.listData = orderedDict
        
        if let matchingKey = forecastReqData.listData.first(where: { $0.key == Date().currentFormattedDate(with: .dateMonYear) })?.key {
            print("Key for value \(Date().currentFormattedDate(with: .dateMonYear)): \(matchingKey)")
            forecastReqData.currentListData = forecastReqData.listData[matchingKey] ?? []
        } else {
            print("Value \(Date().currentFormattedDate(with: .dateMonYear)) not found in the dictionary.")
        }
        
        let keyToRemove = Date().currentFormattedDate(with: .dateMonYear)
        if forecastReqData.listData[keyToRemove] != nil {
            forecastReqData.listData.removeValue(forKey: keyToRemove)
        }
    }
}
