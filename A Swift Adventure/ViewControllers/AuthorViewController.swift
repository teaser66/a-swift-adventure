//
//  AuthorViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import UIKit
import WebKit

class AuthorViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "About the Author"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Image View
        let imageView = UIImageView()
        imageView.image = UIImage(named: "authorImage.jpg")  // Replace with your image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // WebView
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Load Local HTML
        if let filePath = Bundle.main.path(forResource: "author", ofType: "html") {
            let fileURL = URL(fileURLWithPath: filePath)
            let request = URLRequest(url: fileURL)
            webView.load(request)
        }
        
        // Setup Layout Constraints
        NSLayoutConstraint.activate([
            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Image View Constraints
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            // WebView Constraints
            webView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
