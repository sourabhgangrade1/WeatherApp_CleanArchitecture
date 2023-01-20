//
//  WeatherRepository.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeatherForeCast(completion: @escaping (Result<WeatherForeCastResponseModel,
                                                     DataTransferError>) -> Void) -> Cancellable?

    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void)
    func updateSelectedCity(cityDetails: CityDetails)
    func getSelectedCity() -> CityDetails?
}

final class WeatherRepository: WeatherRepositoryProtocol {
    private let netWorkRepository: WeatherNetworkRepositoryProtocol
    private let localRepository: WeatherLocalRepositoryProtocol

    init(netWorkRepository: WeatherNetworkRepositoryProtocol,
         localRepository: WeatherLocalRepositoryProtocol) {
        self.netWorkRepository = netWorkRepository
        self.localRepository = localRepository
    }

    func fetchWeatherForeCast(completion: @escaping (Result<WeatherForeCastResponseModel,
                                                     DataTransferError>) -> Void) -> Cancellable? {
        guard let selectedCityDetails = getSelectedCity() else {
            completion(.failure(.noDataFound))
            return nil
        }
        let requestDTO = ["lat": "\(selectedCityDetails.coord.cityLatitude)",
                          "lon": "\(selectedCityDetails.coord.cityLongitude)",
                          "appid": "\(AppConfiguration.shared.apiKey)",
                          "units":"metric"]
        let task = RepositoryTask()
        _ = netWorkRepository.fetchWeatherForeCast(requestModel: requestDTO,
                                                   completion: { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }

    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void) {
        localRepository.fetchLocations(completion: { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func updateSelectedCity(cityDetails: CityDetails) {
        localRepository.updateSelectedCity(cityDetails: cityDetails)
    }

    func getSelectedCity() -> CityDetails? {
        return localRepository.getSelectedCity()
    }
}
