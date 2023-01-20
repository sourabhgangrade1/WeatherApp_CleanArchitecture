//
//  LocationChangeViewModel.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

struct LocationChangeViewModelActions {
    let dismissScreen: () -> Void
}

class LocationChangeViewModel {
    private let useCase: LocationChangeUseCaseProtocol
    private var actions: LocationChangeViewModelActions?
    var cityDetails: [CityDetails]?
    var filteredCityDetails: [CityDetails]?

    init(useCase: LocationChangeUseCaseProtocol,
         actions: LocationChangeViewModelActions? = nil) {
        self.useCase = useCase
        self.actions = actions
    }

    func fetchLocations(completion: @escaping(() -> Void )) {
        useCase.fetchLocations(completion: { [weak self] result in
            switch result {
            case .success(let responseDTO):
                self?.cityDetails = responseDTO
                self?.filteredCityDetails = responseDTO
                completion()
            case .failure(let error):
                print("Function: \(#function), line: \(#line) Error in update: \(error)")
            }
        })
    }

    func updateSelectedCity(cityDetails: CityDetails) {
        useCase.updateSelectedCity(cityDetails: cityDetails)
        dismissScreen()
    }

    func dismissScreen() {
        actions?.dismissScreen()
    }

    deinit {
    }
}
