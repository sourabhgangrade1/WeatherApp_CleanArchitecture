//
//  WeatherForeCastViewModel.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

class WeatherResponseToDisplayMapper {
    static func convertResponseToDisplay(weatherForeCastResponseModel: WeatherForeCastResponseModel) -> WeatherForeCastDisplayModel? {
        guard let weatherList = weatherForeCastResponseModel.weatherList,
              weatherList.count > 0 else {
            return nil
        }

        var arrayWeatherForecastByDate = [WeatherForeCastByDate]()

        for weatherDetail in weatherList {
            if var WeatherForeCastByDate = arrayWeatherForecastByDate.last {
                let order = Calendar.current.compare(WeatherForeCastByDate.dateTime, to: weatherDetail.dateTime, toGranularity: .day)
                switch order {
                case .orderedDescending:
                    print("DESCENDING")
                case .orderedAscending:
                    arrayWeatherForecastByDate.append(convertWeatherForeCastDetailsToByDate(weatherForeCastDetails: weatherDetail))
                case .orderedSame:
                    WeatherForeCastByDate.weatherForeCastDetails?.append(weatherDetail)
                    let lastIndex = arrayWeatherForecastByDate.count - 1
                    arrayWeatherForecastByDate[lastIndex] = WeatherForeCastByDate
                }
            } else {
                arrayWeatherForecastByDate.append(convertWeatherForeCastDetailsToByDate(weatherForeCastDetails: weatherDetail))
            }
        }
        return WeatherForeCastDisplayModel(WeatherForeCastByDate: arrayWeatherForecastByDate,
                                           cityName: weatherForeCastResponseModel.cityDetails?.cityName ?? "")
    }

    static func convertWeatherForeCastDetailsToByDate(weatherForeCastDetails: WeatherForeCastDetails) -> WeatherForeCastByDate {
        var weatherTypeIcon = "defaultWeatherIcon"
        var weatherType = ""
        if let weatherDetails = weatherForeCastDetails.weatherDetails,
           weatherDetails.count > 0,
           let icon = weatherDetails[0].wetherIcon {
            weatherTypeIcon = icon
            weatherType = weatherDetails[0].weatherType ?? ""
        }
        let arrayWeatherForeCastDetails = [weatherForeCastDetails]
        return WeatherForeCastByDate(dateTime: weatherForeCastDetails.dateTime,
                                     date: weatherForeCastDetails.date,
                                     day: weatherForeCastDetails.day,
                                     weatherType: weatherType,
                                     weatherTypeIcon: weatherTypeIcon,
                                     temperature: weatherForeCastDetails.weatherTemperatureDetails?.temperature ?? 0.0,
                                     temperatureMin: weatherForeCastDetails.weatherTemperatureDetails?.temperatureMin ?? 0.0,
                                     temperatureMax: weatherForeCastDetails.weatherTemperatureDetails?.temperatureMax ?? 0.0,
                                     weatherForeCastDetails: arrayWeatherForeCastDetails)
    }
}
