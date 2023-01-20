//
//  WeatherNetworkRepository.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

protocol WeatherNetworkRepositoryProtocol {
    func fetchWeatherForeCast(requestModel: [String: String],
                              completion: @escaping (Result<WeatherForeCastResponseModel, DataTransferError>) -> Void) -> Cancellable?
}

final class WeatherNetworkRepository {
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension WeatherNetworkRepository: WeatherNetworkRepositoryProtocol {
    func fetchWeatherForeCast(requestModel: [String: String],
                                            completion: @escaping (Result<WeatherForeCastResponseModel, DataTransferError>) -> Void) ->
    Cancellable? {
        let requestDTO = requestModel
        let task = RepositoryTask()
        guard !task.isCancelled else {
            completion(.failure(.noResponse))
            return nil
        }
        let endpoint = APIEndpoints.requestForWeatherDetailsAPI(with: requestDTO, isGetRequest: true)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
