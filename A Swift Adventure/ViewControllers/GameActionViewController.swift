//
//  GameActionViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//


import UIKit
import SwiftUI

class GameActionViewController: UIViewController, CodeShowable {
    var codeKey: String { return "GameActionViewController" }
    
    var incomingAction: ModalType

    // Custom initializer
    init(incomingAction: ModalType) {
        self.incomingAction = incomingAction
        super.init(nibName: nil, bundle: nil) // Initialize the superclass
    }
    
    // Required initializer for cases where you might use a storyboard
    required init?(coder: NSCoder) {
        self.incomingAction = .none
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        print("I am showing \(incomingAction)")
    }
}

