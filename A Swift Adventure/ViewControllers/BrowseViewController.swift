//
//  BrowseViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class BrowseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Basic setup
        self.view.backgroundColor = .white
        
        // Add button to present modal
        let showCodeButton = UIButton(type: .system)
        showCodeButton.setTitle("Show Code", for: .normal)
        showCodeButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        showCodeButton.addTarget(self, action: #selector(showCode), for: .touchUpInside)
        
        self.view.addSubview(showCodeButton)
    }
    
    @objc func showCode() {
        // Present the modal view
        let codeViewController = CodeViewController()
        codeViewController.fileKey = "BrowseViewController"
        self.present(codeViewController, animated: true, completion: nil)
    }
}
