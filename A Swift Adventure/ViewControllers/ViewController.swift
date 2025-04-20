//
//  ViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit
import SwiftUI

class ViewController: UIViewController, CodeShowable {
    var codeKey: String { return "ViewController" }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Create SwiftUI view and embed it in a UIHostingController
        let landingPageView = LandingPageView(
            onLetsGo: { [weak self] in
                self?.openVentureViewController()
            },
            onBrowseWidgets: { [weak self] in
                self?.selectTab(1) // Tab 2 (index starts from 0)
            },
            onTakeMeToFiles: { [weak self] in
                self?.selectTab(2) // Tab 3 (index starts from 0)
            }
        )
        
        let hostingController = UIHostingController(rootView: landingPageView)
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    // MARK: - Navigation Actions
    
    func openVentureViewController() {
        let ventureVC = VentureViewController() 
        navigationController?.pushViewController(ventureVC, animated: true)
    }
    
    func selectTab(_ index: Int) {
        guard let tabBarController = tabBarController else { return }
        tabBarController.selectedIndex = index
    }
}

// SwiftUI View Struct (at the bottom of the view controller file)
struct LandingPageView: View {
    
    var onLetsGo: () -> Void
    var onBrowseWidgets: () -> Void
    var onTakeMeToFiles: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to A Swift Adventure")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Text("Embark on a Swift adventure where your choices shape the journey. Every screen has a code button to reveal the magic behind the scenes. Skip the usual—let’s make it fun!")
                .font(.body)
                .padding()

            Text("Ready to venture?")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            // Buttons
            Button(action: {
                onLetsGo()
            }) {
                Text("Let's go!")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                onBrowseWidgets()
            }) {
                Text("I'll browse the widgets")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            Button(action: {
                onTakeMeToFiles()
            }) {
                Text("Take me to the files")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView(
            onLetsGo: {},
            onBrowseWidgets: {},
            onTakeMeToFiles: {}
        )
    }
}


