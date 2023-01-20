//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()

}

protocol CoordinatorFinishFlow {
    var finishFlow: (() -> Void)? { get set }
}
