//
//  Navigator.swift
//  WeatherApp
//
//  Created by Wipro on 18/01/23.
//

import UIKit

protocol PresentableModel {
    func toPresent() -> UIViewController?
}

protocol NavigatorProtocol: PresentableModel {
    func getViewControllerWith(className: AnyClass) -> UIViewController?
    func topViewController() -> UIViewController?

    func setRootViewController(_ viewController: PresentableModel?)
    func setRootViewController(_ viewController: PresentableModel?, hideBar: Bool)

    func push(_ viewController: PresentableModel?)
    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?)
    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool)
    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?)

    func popViewController()
    func popViewController(animatedTransition: UIViewControllerAnimatedTransitioning?)
    func popViewController(animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool)

    func popToRootViewController(animated: Bool)
    func popToViewController(viewController: PresentableModel?, animated: Bool)

    func present(_ viewController: PresentableModel?)
    func present(_ viewController: PresentableModel?, animated: Bool)

    func dismissViewController()
    func dismissViewController(animated: Bool, completion: (() -> Void)?)
}

final class Navigator: NSObject, NavigatorProtocol {
    private weak var rootController: UINavigationController?
    private var completionHandlers: [UIViewController : () -> Void]
    private var animatedTransition: UIViewControllerAnimatedTransitioning?

    init(rootController: UINavigationController) {
        self.rootController = rootController
        self.completionHandlers = [:]
        super.init()
        self.rootController?.delegate = self
    }

    func toPresent() -> UIViewController? {
        return self.rootController
    }

    func topViewController() -> UIViewController? {
        return rootController?.viewControllers.last
    }

    func getViewControllerWith(className: AnyClass) -> UIViewController? {
        return self.rootController?.viewControllers.filter({ $0.isKind(of: className)}).first
    }

    func setRootViewController(_ viewController: PresentableModel?) {
        self.setRootViewController(viewController, hideBar: false)
    }

    func setRootViewController(_ viewController: PresentableModel?, hideBar: Bool) {
        guard let controller = viewController?.toPresent() else { return }
        self.rootController?.setViewControllers([controller], animated: false)
        self.rootController?.isNavigationBarHidden = hideBar
    }

    func push(_ viewController: PresentableModel?) {
        self.push(viewController, animatedTransition: nil)
    }

    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?) {
        self.push(viewController, animatedTransition: animatedTransition, animated: true)
    }

    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.push(viewController, animatedTransition: animatedTransition, animated: animated, completion: nil)
    }

    func push(_ viewController: PresentableModel?, animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool, completion: (() -> Void)?) {
        self.animatedTransition = animatedTransition
        guard let controller = viewController?.toPresent(),
            (controller is UINavigationController == false)
            else { assertionFailure("Deprecated push UINavigationController."); return }

        if let completion = completion {
            self.completionHandlers[controller] = completion
        }
        self.rootController?.pushViewController(controller, animated: animated)
    }

    func popViewController() {
        self.popViewController(animatedTransition: nil)
    }

    func popViewController(animatedTransition: UIViewControllerAnimatedTransitioning?) {
        self.popViewController(animatedTransition: animatedTransition, animated: true)
    }

    func popViewController(animatedTransition: UIViewControllerAnimatedTransitioning?, animated: Bool) {
        self.animatedTransition = animatedTransition
        if let controller = rootController?.popViewController(animated: animated) {
            self.runCompletion(for: controller)
        }
    }

    func popToViewController(viewController: PresentableModel?, animated: Bool) {
        if let viewControllers = self.rootController?.viewControllers,
           let moduleviewController = viewController {
            for viewController in viewControllers {
                if let viewControllerTemp = moduleviewController as? UIViewController {
                    if viewController == viewControllerTemp {
                        self.rootController?.popToViewController(viewController, animated: animated)
                        break
                    }
                }
            }
        }
    }

    func popToRootViewController(animated: Bool) {
        if let viewControllers = self.rootController?.popToRootViewController(animated: animated) {
            viewControllers.forEach { viewController in
                self.runCompletion(for: viewController)
            }
        }
    }

    func present(_ viewController: PresentableModel?) {
        present(viewController, animated: true)
    }

    func present(_ viewController: PresentableModel?, animated: Bool) {
        guard let viewcontroller = viewController?.toPresent() else { return }
        viewcontroller.modalPresentationStyle = .fullScreen
        toPresent()?.present(viewcontroller, animated: animated, completion: nil)
    }

    func dismissViewController() {
        self.dismissViewController(animated: true, completion: nil)
    }

    func dismissViewController(animated: Bool, completion: (() -> Void)?) {
        toPresent()?.dismiss(animated: animated, completion: completion)
    }

    private func runCompletion(for viewController: UIViewController) {
        guard let completionHandler = self.completionHandlers[viewController] else { return }
        completionHandler()
        completionHandlers.removeValue(forKey: viewController)
    }
}

extension Navigator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animatedTransition
    }
}

// MARK: - UIViewController + Coordinator
extension UIViewController: PresentableModel {
    func toPresent() -> UIViewController? {
        return self
    }
}

