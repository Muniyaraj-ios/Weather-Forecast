//
//  APIService.swift
//  Weather Forecast App
//
//  Created by Apple on 12/01/24.
//

import Foundation

class APIService{
    private let baseURL = "https://api.openweathermap.org/"
    private let apikey = "8d9e021a91501c3792da59fee7e913a8"

    func fetchWeatherData<T: Codable>(endPoints: APIEndPoints,completion: @escaping (Result<T, Error>) -> Void) {
        guard let URL = URL(string: baseURL + endPoints.value + apikey)else{return}
        
        print("base URL : \(URL.absoluteString)")
        URLSession.shared.dataTask(with: URL) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let noDataError = NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(T.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
