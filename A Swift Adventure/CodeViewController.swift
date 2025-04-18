//
//  CodeViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit
import WebKit

class CodeViewController: UIViewController {
    
    var webView: WKWebView!
    var fileKey: String?
    var codeURLs: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up background color
        self.view.backgroundColor = .white
        
        // Add close button at the top
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
        self.view.addSubview(closeButton)
        
        // Add "Open in Browser" button
        let openInBrowserButton = UIButton(type: .system)
        openInBrowserButton.setTitle("Open in Browser", for: .normal)
        openInBrowserButton.translatesAutoresizingMaskIntoConstraints = false
        openInBrowserButton.addTarget(self, action: #selector(openInBrowser), for: .touchUpInside)
        self.view.addSubview(openInBrowserButton)
        
        // Add WebView
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        
        // Load the JSON file and parse it
        loadURLsFromJSON()
        
        // Load the appropriate raw code URL based on the fileKey
        if let key = fileKey, let urlString = codeURLs[key], let url = URL(string: urlString) {
            loadCodeFromURL(url)
        } else {
            print("Error: No URL found for the provided key")
        }
        
        // Apply Auto Layout constraints
        NSLayoutConstraint.activate([
            // Position close button at the top
            closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            closeButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 100),
            
            // Position "Open in Browser" button below the close button
            openInBrowserButton.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            openInBrowserButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            openInBrowserButton.heightAnchor.constraint(equalToConstant: 50),
            openInBrowserButton.widthAnchor.constraint(equalToConstant: 200),
            
            // Position WebView below the "Open in Browser" button
            webView.topAnchor.constraint(equalTo: openInBrowserButton.bottomAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Page finished loading")

            // Inject viewport meta for mobile-friendly rendering
            let viewportScript = """
            var meta = document.createElement('meta');
            meta.setAttribute('name', 'viewport');
            meta.setAttribute('content', 'width=device-width, initial-scale=1.0');
            document.getElementsByTagName('head')[0].appendChild(meta);
            """
            
            webView.evaluateJavaScript(viewportScript, completionHandler: nil)
        }
    
    @objc func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openInBrowser() {
        // Open the raw GitHub URL in Safari
        if let key = fileKey, let urlString = codeURLs[key], let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func loadURLsFromJSON() {
        if let url = Bundle.main.url(forResource: "CodeFiles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let json = try decoder.decode([String: String].self, from: data)
                codeURLs = json
            } catch {
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }
    }
    
    func loadCodeFromURL(_ url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching code: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let code = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    let escapedCode = self?.escapeForHTML(code)
                    self?.webView.loadHTMLString(escapedCode ?? "", baseURL: nil)
                }
            }
        }
        
        task.resume()
    }
    
    func escapeForHTML(_ code: String) -> String {
        return code
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\n", with: "<br/>")
            .replacingOccurrences(of: " ", with: "&nbsp;")
    }
}
