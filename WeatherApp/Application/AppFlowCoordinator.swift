//
//  AppFlowCoordinator.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

final class AppFlowCoordinator: BaseCoordinator {
    private let appDIContainer: AppDIContainer
    private let navigator: NavigatorProtocol

    init(appDIContainer: AppDIContainer,
         navigator: Navigator) {
        self.appDIContainer = appDIContainer
        self.navigator = navigator
    }

    override func start() {
        self.showWeatherHomeScreen()
    }

    private func showWeatherHomeScreen() {
        let container = appDIContainer.weatherForeCastSceneDIContainer()
        let flowCoordinator = container.makeWeatherForeCastFlowCoordinator(navigator: navigator)
        self.addDependency(flowCoordinator)
        flowCoordinator.start()
    }
}
