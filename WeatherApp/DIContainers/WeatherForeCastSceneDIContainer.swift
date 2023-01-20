//
//  WeatherForeCastSceneDIContainer.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

final class WeatherForeCastSceneDIContainer {
    private let dependencies: Dependencies
    private let sharedRepository: WeatherRepository
    
    init(dependencies: Dependencies,
         sharedRepository: WeatherRepository) {
        self.dependencies = dependencies
        self.sharedRepository = sharedRepository
    }
    
    // MARK: - Use Cases
    private func makeWeatherForeCastUseCase() -> WeatherForeCastUseCase {
        return WeatherForeCastUseCase(repository: makeWeatherRepository())
    }

    private func makeWeatherForeCastUseCase() -> LocationChangeUseCase {
        return LocationChangeUseCase(repository: makeWeatherRepository())
    }
    
    // MARK: - Repositories
    private func makeWeatherRepository() -> WeatherRepository {
        return sharedRepository
    }

    // MARK: - ViewModel
    private func makeWeatherForeCastViewModel(actions: WeatherForeCastViewModelActions) -> WeatherForeCastViewModel {
        return WeatherForeCastViewModel(useCase: makeWeatherForeCastUseCase(), actions: actions)
    }

    private func makeLocationChangeViewModel(actions: LocationChangeViewModelActions) -> LocationChangeViewModel {
        return LocationChangeViewModel(useCase: makeWeatherForeCastUseCase(), actions: actions)
    }
    
    // MARK: - Flow Coordinators
    func makeWeatherForeCastFlowCoordinator(navigator: NavigatorProtocol) -> WeatherHomeFlowCoordinator {
        return WeatherHomeFlowCoordinator(navigator: navigator, dependencies: self)
    }
}

extension WeatherForeCastSceneDIContainer: WeatherHomeFlowCoordinatorDependencies {
    func makeWeatherForeCastHomeScreen(actions: WeatherForeCastViewModelActions) -> HomeViewController {
        return HomeViewController.getInstance(with: makeWeatherForeCastViewModel(actions: actions))
    }

    func makeLocationChangeScreen(actions: LocationChangeViewModelActions) -> LocationChangeViewController {
        return LocationChangeViewController.getInstance(with: makeLocationChangeViewModel(actions: actions))
    }
}
