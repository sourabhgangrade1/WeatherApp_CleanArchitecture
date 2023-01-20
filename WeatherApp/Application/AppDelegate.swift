//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit
import Network

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var rootController: UINavigationController {
        guard let rootViewController = self.window?.rootViewController as? UINavigationController else {
            fatalError("Root view not found")
        }
        return rootViewController
    }
    private lazy var appFlowCoordinator = AppFlowCoordinator(appDIContainer: AppDIContainer(),
                                                             navigator: Navigator(rootController: self.rootController))



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureWindowRootController()
        appFlowCoordinator.start()
        networkListener()
        return true
    }
    
    private func configureWindowRootController() {
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Reachability check
extension AppDelegate {
    /// Network Listener - Lisening network changes
    private func networkListener() {
        let queue = DispatchQueue(label: "Monitor")
        let monitor = NWPathMonitor()
        monitor.start(queue: queue)
        _ = NWPathMonitor(requiredInterfaceType: .loopback)
        
        monitor.pathUpdateHandler = { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print("Network status -", isNetworkConnectionExist())
                NotificationCenter.default.post(name: .internetFail, object: nil, userInfo: ["isReachable": isNetworkConnectionExist()])
            }
        }
    }
}

extension Notification.Name {
    static let internetFail: Notification.Name = .init("com.weather.internetFail")
}



