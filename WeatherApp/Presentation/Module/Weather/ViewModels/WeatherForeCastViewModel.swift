//
//  WeatherForeCastViewModel.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

struct WeatherForeCastViewModelActions {
    let showLocationChangeScreen: () -> Void
}

class WeatherForeCastViewModel {
    private let useCase: WeatherForeCastUseCaseProtocol
    private var actions: WeatherForeCastViewModelActions?
    var weatherDetailsModel: WeatherForeCastDisplayModel?

    init(useCase: WeatherForeCastUseCaseProtocol,
         actions: WeatherForeCastViewModelActions? = nil) {
        self.useCase = useCase
        self.actions = actions
    }
    
    func fetchWeatherDetails(completion: @escaping(() -> Void )) {
        useCase.fetchWeatherForeCast(completion: { [weak self] result in
            switch result {
            case .success(let responseDTO):
                print("Function: \(#function), line: \(#line) Successfully updated: \(responseDTO)")
                self?.weatherDetailsModel = WeatherResponseToDisplayMapper.convertResponseToDisplay(weatherForeCastResponseModel: responseDTO)
                completion()
            case .failure(let error):
                switch error {
                case .noDataFound:
                    self?.showLocationChangeScreen()
                default:
                    print("Function: \(#function), line: \(#line) Error in update: \(error)")
                }
            }
        })
    }

    func showLocationChangeScreen() {
        actions?.showLocationChangeScreen()
    }

    deinit {
    }
}

extension WeatherForeCastViewModel {

    func getCityName() -> String {
        return weatherDetailsModel?.cityName ?? ""
    }

    func getTemperatureType(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return weatherList[index].weatherType
    }

    func getTemperatureTypeImage(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return weatherList[index].weatherTypeIcon
    }

    func getCurrentTemperature(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return "\(weatherList[index].temperature)°"
    }

    func getMaxTemperature(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return "\(weatherList[index].temperatureMax)°"
    }

    func getMinTemperature(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return "\(weatherList[index].temperatureMin)°"
    }

    func getTodaysDate(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return "Today \(weatherList[index].date)"
    }

    func getTodaysDay(index: Int) -> String {
        guard let weatherList = weatherDetailsModel?.WeatherForeCastByDate,
              weatherList.count > index else {
            return ""
        }
        return weatherList[index].day
    }
}
