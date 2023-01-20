//
//  WeatherForeCastDisplayModel.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

struct WeatherForeCastDisplayModel {
    let WeatherForeCastByDate: [WeatherForeCastByDate]
}

struct WeatherForeCastByDate {
    let dateTime: Date
    let date: String
    let day: String
    let weatherTypeIcon: String
    let temperatureMin, temperatureMax: Double?
    var weatherForeCastDetails: [WeatherForeCastDetails]?
}
