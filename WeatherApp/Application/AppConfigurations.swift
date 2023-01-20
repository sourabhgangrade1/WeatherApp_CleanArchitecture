//
//  AppConfiguration.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation
import UIKit

final class AppConfiguration {
    static let shared = AppConfiguration()
    private init() {}

    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
}
