//
//  MainTabbarController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tab1 = UINavigationController(rootViewController: ViewController())
        let tab2 = UINavigationController(rootViewController: BrowseViewController())
        let tab3 = UINavigationController(rootViewController: AboutViewController())
        
        tab1.tabBarItem = UITabBarItem(title: "Venture", image: UIImage(systemName: "gamecontroller"), tag: 0)
        tab2.tabBarItem = UITabBarItem(title: "Browse", image: UIImage(systemName: "list.clipboard"), tag: 1)
        tab3.tabBarItem = UITabBarItem(title: "About", image: UIImage(systemName: "doc.richtext.th"), tag: 2)
        
        viewControllers = [tab1, tab2, tab3]
    }
}

