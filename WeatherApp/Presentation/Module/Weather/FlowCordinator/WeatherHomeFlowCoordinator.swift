//
//  WeatherHomeFlowCoordinator.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation
import UIKit

protocol WeatherHomeFlowCoordinatorDependencies {
    func makeWeatherForeCastHomeScreen(actions: WeatherForeCastViewModelActions) -> HomeViewController
    func makeLocationChangeScreen(actions: LocationChangeViewModelActions) -> LocationChangeViewController
}

final class WeatherHomeFlowCoordinator: BaseCoordinator {
    private let navigator: NavigatorProtocol
    private let dependencies: WeatherHomeFlowCoordinatorDependencies

    init(navigator: NavigatorProtocol, dependencies: WeatherHomeFlowCoordinatorDependencies) {
        self.navigator = navigator
        self.dependencies = dependencies
    }

    override func start() {
        showWeatherForeCastHomeScreen()
    }

    // MARK: - Navigation
    private func showWeatherForeCastHomeScreen() {
        let viewController = weatherForeCastHomeViewController()
        self.navigator.setRootViewController(viewController, hideBar: true)
    }
    
    private func showLocationChangeScreen() {
        let viewController = locationChangeViewController()
        self.navigator.present(viewController)
    }
    
    private func dismissScreen() {
        self.navigator.dismissViewController()
    }

    // MARK: - UIViewController creation
    private func weatherForeCastHomeViewController() -> UIViewController {
        let actions = WeatherForeCastViewModelActions(showLocationChangeScreen: showLocationChangeScreen)
        let viewController = dependencies.makeWeatherForeCastHomeScreen(actions: actions)
        return viewController
    }
    
    private func locationChangeViewController() -> UIViewController {
        let actions = LocationChangeViewModelActions(dismissScreen: dismissScreen)
        let viewController = dependencies.makeLocationChangeScreen(actions: actions)
        return viewController
    }
}
