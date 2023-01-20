//
//  BaseCoordinator.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

class BaseCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()

    // MARK: - Public methods
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }

        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    // MARK: - Coordinator
    func start() { }
}
