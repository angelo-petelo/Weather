//
//  WeatherData.swift
//  Weather
//
//  Created by Nicholas Angelo Petelo on 5/19/21.
//

struct WeatherData: Codable {
    let main: MainData
}

struct MainData: Codable {
    let temp: Double
}
