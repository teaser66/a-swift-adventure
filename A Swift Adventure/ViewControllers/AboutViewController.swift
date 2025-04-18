//
//  AboutViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class AboutViewController: UIViewController, CodeShowable {
    var codeKey: String { return "AboutViewController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Basic setup
        self.view.backgroundColor = .white
    }
}
