//
//  WeatherService.swift
//  Weather
//
//  Created by Nicholas Angelo Petelo on 5/19/21.
//

import Foundation
import CoreLocation

class WeatherService {
    
    private let headers = [
        "x-rapidapi-key": "ec63cd2e45msh299c5f9975e731cp104512jsnc7481dcfb607",
        "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com"
    ]
    
    private let baseUrl = "https://community-open-weather-map.p.rapidapi.com"
        
    public func getCurrentWeatherWithCityAndCoords(cityName: String, coords: CLLocationCoordinate2D, completion: @escaping (Double) -> Void) {
        let urlString = baseUrl + "/weather?units=imperial&q=\(cityName)&lat=\(coords.latitude)&lon=\(coords.longitude)"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error api")
            } else if let data = data {
                let decoder = JSONDecoder()
                do {
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData.main.temp)
                } catch {
                    print("error decode")
                }
            }
        }.resume()
    }
    
    deinit {
        print("weather service deinit")
    }
}
