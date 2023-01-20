//
//  WeatherForeCastUseCase.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

protocol WeatherForeCastUseCaseProtocol {
    func fetchWeatherForeCast(completion: @escaping (Result<WeatherForeCastResponseModel,
                                                     DataTransferError>) -> Void)
}

final class WeatherForeCastUseCase: WeatherForeCastUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func fetchWeatherForeCast(completion: @escaping (Result<WeatherForeCastResponseModel,
                                                     DataTransferError>) -> Void) {
        _ = repository.fetchWeatherForeCast(completion: { result in
            completion(result)
        })
    }
}
