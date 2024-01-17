//
//  LocationManager.swift
//  Weather Forecast App
//
//  Created by Apple on 12/01/24.
//

import SwiftUI
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    var unitType: UnitType = .metric
    @Published var isLocLoading: Bool = false

    @Published var location: CLLocation?
    
    @Published var weatherReqData: CurrentWeatherRequest = CurrentWeatherRequest()
    
    private let apiService: APIService = APIService()
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
        self.isLocLoading = true
        print("Location manager error: \(error.localizedDescription)")
    }
    
    func fetchAPIResult() {
        isLocLoading = true
        if let location = self.location,!weatherReqData.isLoading{
            self.getCityName(location) { cityName in
                if let cityName,!cityName.isEmpty{
                    self.getWeatherData(location: location,city: cityName)
                }else{
                    print("Unable to get city location")
                }
            }
        }
    }
    func getData(location: CLLocation){
//        (lat: "9.512137", lon: "77.634087")
        guard let request = apiManager?.getURLRequest(endPoint: .current(lat: location.coordinate.latitude.description, lon: location.coordinate.longitude.description, units: unitType), method: .get, param: nil) else{return}
        apiManager?.getAllData(request) { (result: Results<LoginModel,Error>) in
            switch result{
            case .success(let response):
                print("response msg : ",response.message)
            case .failure(let error):
                print("error msg : ",error.localizedDescription)
            }
        }
    }
    func getWeatherData(location: CLLocation,city name: String){
        self.weatherReqData.isLoading = true
        let endPoint: APIEndPoints = .currentCity(cityName: name, countryCode: "", units: .metric)//.current(lat: location.coordinate.latitude.description, lon: location.coordinate.longitude.description, units: unitType)
        guard let request = apiManager?.getURLRequest(endPoint: endPoint, method: .get, param: nil) else{return}
        //apiService.fetchWeatherData(endPoints: .current(lat: location.coordinate.latitude.description, lon: location.coordinate.longitude.description)){ (result: Result<WeatherResponse,Error>) in
        apiManager?.getAllData(request) { (result: Results<WeatherResponse,Error>) in
            DispatchQueue.main.async {
                self.weatherReqData.isLoading = false
                switch result {
                    case .success(let weatherResponse):
                    self.weatherReqData.weatherData = weatherResponse
                    print("Weather in \(weatherResponse.name): \(weatherResponse.weather[0].description) | \(weatherResponse.main.temp)")
                    case .failure(let error):
                    self.weatherReqData.isError = error
                    print("Error fetching weather data: \(error)")
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
