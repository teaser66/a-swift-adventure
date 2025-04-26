//
//  MainTabbarController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let ventureNavigationDelegate = VentureNavigationDelegate()
    private let savedTabKey = "lastSelectedTab"

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        let tab1 = UINavigationController(rootViewController: ViewController())
        tab1.delegate = ventureNavigationDelegate
        let tab2 = UINavigationController(rootViewController: BrowseViewController())
        let tab3 = UINavigationController(rootViewController: AboutViewController())
        
        tab1.tabBarItem = UITabBarItem(title: "Venture", image: UIImage(systemName: "gamecontroller"), tag: 0)
        tab2.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "list.clipboard"), tag: 1)
        tab3.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "doc.richtext.th"), tag: 2)
        
        viewControllers = [tab1, tab2, tab3]
        
        // Restore previously selected tab
        let lastIndex = UserDefaults.standard.integer(forKey: savedTabKey)
        selectedIndex = lastIndex
    }
    
    // Save tab selection
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        UserDefaults.standard.set(selectedIndex, forKey: savedTabKey)
    }
    
    // Prevent auto-pop to root on re-tap of the current tab
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // If the selected tab is tapped again, don't reselect
        if let selectedVC = selectedViewController,
           selectedVC == viewController {
            return false
        }
        return true
    }
}


