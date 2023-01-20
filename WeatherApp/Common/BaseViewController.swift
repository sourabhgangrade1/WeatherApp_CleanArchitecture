//
//  BaseViewController.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var overlay = UIView(frame: view.frame)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        removeInternetFailObserver()
        if self.isMovingFromParent {
//            print("Back Button Pressed")
        }
    }

    func showLoader() {
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.center = overlay.center
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .large
        loadingIndicator.color = UIColor.white
        loadingIndicator.startAnimating()
        overlay.addSubview(loadingIndicator)
        view.addSubview(overlay)
    }

    func removeLoader() {
        overlay.removeFromSuperview()
    }
}

// MARK: - Reachability check
extension BaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addInternetFailObserver()
    }

    private func addInternetFailObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReachabilityNotification(notification:)),
                                               name: .internetFail,
                                               object: nil)
    }

    private func removeInternetFailObserver() {
        NotificationCenter.default.removeObserver(self, name: .internetFail, object: nil)
    }

    @objc private func handleReachabilityNotification(notification: Notification) {
        guard let isReachable = notification.userInfo?["isReachable"] as? Bool else {
            return
        }

        if !isReachable {
            self.showNoInternetAlert()
        }
    }
}

extension BaseViewController {
    public func showAlert(title: String = "",
                          message: String,
                          alertStyle: UIAlertController.Style = .alert,
                          actionTitles: [String],
                          actionStyles: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)]) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
            let action  = actions.first
            for(index, indexTitle) in actionTitles.enumerated() {
                let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: action)
                alertController.addAction(action)
            }
            self.present(alertController, animated: true)
        }
    }

    func showNoInternetAlert() {
        let title = "Warning"
        let message = "No internet"
        self.showAlert(title: title,
                       message: message,
                       actionTitles: ["ok"],
                       actionStyles: [.default],
                       actions: [ {_ in } ])
    }
}
