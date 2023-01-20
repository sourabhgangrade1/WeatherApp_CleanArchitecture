//
//  WeatherLocalRepository.swift
//  WeatherApp
//
//  Created by Wipro on 19/01/23.
//

import Foundation

protocol WeatherLocalRepositoryProtocol {
    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void)
    func updateSelectedCity(cityDetails: CityDetails)
    func getSelectedCity() -> CityDetails?
}

final class WeatherLocalRepository: WeatherLocalRepositoryProtocol {

//    private var selectedCity: CityDetails = CityDetails(cityName: "Hyderabad",
//                                                        coord: Coord(cityLatitude: 17.360589, cityLongitude: 78.4740613),
//                                                        cityCountryCode: "IN",
//                                                        cityStateName: "Telangana")
    private var selectedCity: CityDetails?

    func fetchLocations(completion: @escaping (Result<[CityDetails], DataTransferError>) -> Void) {
        if let url = Bundle.main.url(forResource: "city_list", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([CityDetails].self, from: data)
                completion(.success(jsonData))
            } catch {
                print("error:\(error)")
                completion(.failure(.noDataFound))
            }
        }
    }

    func updateSelectedCity(cityDetails: CityDetails) {
        selectedCity = cityDetails
    }

    func getSelectedCity() -> CityDetails? {
        return selectedCity
    }
}
