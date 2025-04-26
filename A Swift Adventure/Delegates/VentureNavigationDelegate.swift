//
//  VentureNavigationDelegate.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/26/25.
//

import UIKit

class VentureNavigationDelegate: NSObject, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is VentureViewController {
            viewController.modalPresentationStyle = .fullScreen
        }
    }
}
