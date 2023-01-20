//
//  WeatherForeCastResponseModel.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

// MARK: - Response
struct WeatherForeCastResponseModel: Codable {
    let weatherList: [WeatherForeCastDetails]?
    let cityDetails: CityDetails?
    
    enum CodingKeys: String, CodingKey {
        case weatherList = "list"
        case cityDetails = "city"
    }
}

struct WeatherForeCastDetails: Codable {
    let dateInt: Int
    let weatherTemperatureDetails: WeatherTemperatureDetails?
    let weatherDetails: [WeatherDetails]?
    
    enum CodingKeys: String, CodingKey {
        case dateInt = "dt"
        case weatherTemperatureDetails = "main"
        case weatherDetails = "weather"
    }

    var dateTime: Date {
        // convert Int to TimeInterval (typealias for Double)
        let timeInterval = TimeInterval(dateInt)

        // create & return NSDate from Double (NSTimeInterval)
        return Date(timeIntervalSince1970: timeInterval)
    }

    var date: String {
        // Formatted date
        return dateTime.getLongDate()
    }

    var day: String {
        // Formatted date
        return dateTime.getDay()
    }
}

// MARK: - WeatherTemperatureDetails
struct WeatherTemperatureDetails: Codable {
    let temperature, temperatureMin, temperatureMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case temperatureMin = "temp_min"
        case temperatureMax = "temp_max"
    }
}

// MARK: - WeatherDetails
struct WeatherDetails: Codable {
    let weatherType, wetherIcon: String?
    
    enum CodingKeys: String, CodingKey {
        case weatherType = "main"
        case wetherIcon = "icon"
    }
}

struct WeatherForeCastDisplayModel {
    let WeatherForeCastByDate: [WeatherForeCastByDate]
    let cityName: String
}

struct WeatherForeCastByDate {
    let dateTime: Date
    let date: String
    let day: String
    let weatherType: String
    let weatherTypeIcon: String
    let temperature, temperatureMin, temperatureMax: Double
    var weatherForeCastDetails: [WeatherForeCastDetails]?
}
