//
//  UIStoryboard+Identifier.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import Foundation

import UIKit

extension UIStoryboard {
    struct Identifier: RawRepresentable {
        let rawValue: String
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    convenience init(identifier: Identifier) {
        self.init(name: identifier.rawValue, bundle: .main)
    }

    func instantiateViewController<T: UIViewController>(isInitial: Bool = false) -> T {
        let viewController = isInitial ? instantiateInitialViewController() : instantiateViewController(withIdentifier: String(describing: T.self))
        guard let typedViewController = viewController as? T else {
            // fatalError("Unable to instantiate the view controller as \(T.self) from storyboard \(self)")
            // TO:DO -Need to update
            return T()
        }
        return typedViewController
    }
}

extension UIStoryboard.Identifier {
    static let main = UIStoryboard.Identifier(rawValue: "Main")
    static let home = UIStoryboard.Identifier(rawValue: "HomeStoryboard")
    
}
