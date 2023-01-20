//
//  LocationChangeUseCase.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

protocol LocationChangeUseCaseProtocol {
    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void)
    func updateSelectedCity(cityDetails: CityDetails)
}

final class LocationChangeUseCase: LocationChangeUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void) {
        repository.fetchLocations(completion: { result in
            completion(result)
        })
    }

    func updateSelectedCity(cityDetails: CityDetails) {
        repository.updateSelectedCity(cityDetails: cityDetails)
    }
}
