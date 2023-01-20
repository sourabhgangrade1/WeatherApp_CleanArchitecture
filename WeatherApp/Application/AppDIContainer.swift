//
//  AppDIContainer.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

final class AppDIContainer {
    // MARK: - Network
    var apiDataTransferService: DataTransferService {
        let config = ApiDataNetworkConfig(baseURL: URL(string: AppConfiguration.shared.apiBaseURL)!,
                                          headers: [:],
                                          queryParameters: [:])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }

    lazy var sharedAppDataService: WeatherRepository = {
        return WeatherRepository(netWorkRepository: sharedNetworkService,
                                 localRepository: sharedLocalService)
    }()

    lazy var sharedNetworkService: WeatherNetworkRepository = {
        return WeatherNetworkRepository(dataTransferService: apiDataTransferService)
    }()

    lazy var sharedLocalService: WeatherLocalRepository = {
        return WeatherLocalRepository()
    }()

    lazy var weatherForeCastDependencies = Dependencies(apiDataTransferService: apiDataTransferService)

    // MARK: - DIContainers of scenes
    func weatherForeCastSceneDIContainer() -> WeatherForeCastSceneDIContainer {
        return WeatherForeCastSceneDIContainer(dependencies: weatherForeCastDependencies,
                                               sharedRepository: sharedAppDataService)
    }
}
