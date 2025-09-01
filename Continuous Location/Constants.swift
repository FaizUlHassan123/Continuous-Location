//
//  Constants.swift
//  Continuous Location
//
//  Created by Faiz Ul Hassan on 3/15/25.
//
import UIKit

class Constants {

    static var lat: Double = 0.0
    static var long: Double = 0.0

}

// MARK: UIViewController Extensions

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController()
        }
        if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? self
        }
        return self
    }
}

extension UIApplication {
    static var topViewController: UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return window.rootViewController?.topMostViewController()
    }
}
