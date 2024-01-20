//
//  APIManager.swift
//  Weather Forecast App
//
//  Created by Apple on 12/01/24.
//

import Foundation
enum UnitType: String{
    case standard
    case metric
    case deg
    var deVal: String{
        switch self{
        case .metric: return "°C"
        case .standard: return "°F"
        case .deg: return "°"
        }
    }
}

enum APIEndPoints{
    case current(lat: String,lon: String,units: UnitType)
    case currentCity(cityName: String,countryCode: String,units: UnitType)
    case forecastCity(cityName: String,Countrycode: String,units: UnitType)
    case forcast(lat: String,lon: String,units: UnitType)
    
    var value: String{
        switch self{
        case .current(let lat,let lon,let unit): return "data/2.5/weather?lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)&appid="
        case .forcast(let lat,let lon,let unit): return "data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=\(unit.rawValue)&appid="
            
        case .currentCity(cityName: let cityName, countryCode: let countryCode, units: let unit):
            return "data/2.5/weather?q=\(cityName)\(countryCode.isEmpty ? "" : ",\(countryCode)")&units=\(unit.rawValue)&appid="
        case .forecastCity(cityName: let cityName, Countrycode: let Countrycode, units: let unit):
            return "data/2.5/forecast?q=\(cityName)\(Countrycode.isEmpty ? "" : ",\(Countrycode)")&units=\(unit.rawValue)&appid="
        }
    }
}

enum Results<T,F>{
    case success(T)
    case failure(F)
}

public typealias Parameters = [String: Any]

class APIManger{
    private let baseURL = "https://api.openweathermap.org/"
    private let apikey = "" // Paste Here the API key, Weather API key are Attached in the Documentations.
    
    typealias CompletionHandler<T> = (Results<T,Error>) -> Void
    
    let session = URLSession.shared
    
    func getURLRequest(endPoint: APIEndPoints,method: HTTPMethod,param: Parameters?) -> URLRequest?{
        guard let url = URL(string: baseURL + endPoint.value + apikey) else{return nil}
        print("base URL : \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let param{
            let jsonData = try! JSONSerialization.data(withJSONObject: param)
            request.httpBody = jsonData
        }
        return request
    }
    func getAllData<T: BaseSwiftJson>(_ req: URLRequest,closure: @escaping CompletionHandler<T>){
        session.dataTask(with: req) { data, response, error in
            if let error{
                print("Error : \(error.localizedDescription)")
                closure(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse{
                print("Status Code : ",response.statusCode)
            }
            if let data{
                let jsonRes = try! JSONSerialization.jsonObject(with: data, options: [])
                print("jsonRes : \(jsonRes)")
                if let jsonArr = jsonRes as? Parameters{
                    //print("JSon Arr : \(jsonArr)")
                    closure(.success(T.init(jsonArr)))
                }
            }
        }.resume()
    }
}

public struct HTTPMethod{
    public static let get = HTTPMethod(rawValue: "GET")
    public let rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
protocol BaseSwiftJson {
    init(_ dict: Parameters)
}

class LoginModel: BaseSwiftJson{
    var message: String = ""
    
    required init(_ dict: Parameters) {
        self.message = dict["message"] as? String ?? ""
    }
}
