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
        let arrayWeatherForeCastDetails = [weatherForeCastDetails]
        return WeatherForeCastByDate(dateTime: weatherForeCastDetails.dateTime,
                                     weatherForeCastDetails: arrayWeatherForeCastDetails)
    }
}
