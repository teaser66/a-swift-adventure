//
//  Extensions.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

extension UIApplication {
    func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}


extension String: Identifiable {
    public var id: String { self }
}

// Extend ModalType to work with .sheet
extension ModalType: Identifiable {
    var id: String { self.rawValue }
}

// Find split view if ipad is trying ot force one
extension UIViewController {
    var nearestSplitViewController: UISplitViewController? {
        var parentVC = self.parent
        while parentVC != nil {
            if let splitVC = parentVC as? UISplitViewController {
                return splitVC
            }
            parentVC = parentVC?.parent
        }
        return nil
    }
}
