//
//  VentureViewContrloller.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import UIKit

class VentureViewController: UIViewController, CodeShowable {
    var codeKey: String { return "VentureViewController" }
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    var codeFileKeys: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }
    
}
