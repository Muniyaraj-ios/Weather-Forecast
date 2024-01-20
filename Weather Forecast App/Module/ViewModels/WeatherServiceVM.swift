//
//  WeatherServiceVM.swift
//  Weather Forecast App
//
//  Created by Apple on 14/01/24.
//

import Foundation
import CoreLocation

class WeatherServiceVM: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    private var locationManager = CLLocationManager()
    @Published var isLocLoading: Bool = false
    @Published var isLocDeny: Bool = false
    @Published var location: CLLocation?
    
    var unitType: UnitType = .metric
    @Published var weatherReqData: CurrentWeatherRequest = CurrentWeatherRequest()
    @Published var forecastReqData: ForecastWeatherRequest = ForecastWeatherRequest()
    
    let apiManager: APIManger? = APIManger()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            self.location = location
            print("Last loc : \(location.coordinate.latitude),\(location.coordinate.longitude)")
            self.fetchAPIResult()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //self.isLocLoading = true
        self.isLocDeny = false
        print("Location manager error: \(error.localizedDescription)")
    }
}
extension WeatherServiceVM{
    func fetchAPIResult() {
        guard !isLocLoading else{return}
        self.isLocLoading = true
        if let location = self.location,!weatherReqData.isLoading{
            self.getCityName(location) { cityName in
                if let cityName,!cityName.isEmpty{
                    self.getWeatherData(location: location,city: cityName)
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        self.getForecastData(city: cityName)
                    }
                }else{
                    print("Unable to get city location")
                }
            }
        }
    }
    private func getCityName(_ location: CLLocation,completion: @escaping(String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            if let city = placemark.locality {
                print("City Name : \(city)")
                completion(city)
            } else {
                completion(nil)
            }
        }
    }
}
extension WeatherServiceVM{
    func getWeatherData(location: CLLocation,city name: String){
        self.weatherReqData.isLoading = true
        let endPoint: APIEndPoints = .currentCity(cityName: name, countryCode: "", units: .metric)
        //.current(lat: location.coordinate.latitude.description, lon: location.coordinate.longitude.description, units: unitType)
        guard let request = apiManager?.getURLRequest(endPoint: endPoint, method: .get, param: nil) else{return}
        apiManager?.getAllData(request) { (result: Results<WeatherResponse,Error>) in
            DispatchQueue.main.async {
                self.weatherReqData.isLoading = false
                switch result {
                    case .success(let weatherResponse):
                    if weatherResponse.cod == 200{
                        self.weatherReqData.isError = nil
                        self.weatherReqData.weatherData = weatherResponse
                        //print("Weather in \(weatherResponse.name): \(weatherResponse.weather[0].description) | \(weatherResponse.main.temp)")
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
    func getForecastData(city name: String){
        self.forecastReqData.isLoading = true
        /*DispatchQueue.main.asyncAfter(deadline: .now()+3){
            self.forecastReqData.isLoading = false
        }*/
        let endPoint: APIEndPoints = .forecastCity(cityName: name, Countrycode: "", units: .metric)
        guard let request = apiManager?.getURLRequest(endPoint: endPoint, method: .get, param: nil) else{return}
        apiManager?.getAllData(request) { (result: Results<WeatherData,Error>) in
            DispatchQueue.main.async {
                self.forecastReqData.isLoading = false
                switch result {
                    case .success(let weatherData):
                    //print("weatherData : \(weatherData)")
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
    func customizeListData(_ weathersList: [WeatherData.WeatherDetails]){
        forecastReqData.listData = [:]
        for (i,val) in weathersList.enumerated(){
            let dateForm = weathersList[i].dt_txt.formatDate(with: .dateMonYear)
            if forecastReqData.listData[dateForm] == nil{
                forecastReqData.listData[dateForm] = [val]
            }else{
                forecastReqData.listData[dateForm]?.append(val)
            }
        }
        //print("\n-------------------------\n")
       // print("forecastReqData : \(String(describing: forecastReqData.listData))")
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
struct CurrentWeatherRequest {
    var isLoading: Bool = false
    var weatherData: WeatherResponse? = nil
    var isError: Error? = nil
}
struct ForecastWeatherRequest {
    var isLoading: Bool = false
    var weatherData: WeatherData? = nil
    var isError: Error? = nil
    var listData: [String: [WeatherData.WeatherDetails]] = [:]
    var currentListData: [WeatherData.WeatherDetails] = []
}
