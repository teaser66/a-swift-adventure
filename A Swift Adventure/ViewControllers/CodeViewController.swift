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
    
    private var originalFileKey: String?
    private var isShowingOwnCode = false
    private var selfCodeButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        originalFileKey = fileKey // Store the original key

        
        // Create styled buttons
        let closeButton = makeStyledButton(title: "Close", action: #selector(closeModal))
        selfCodeButton = makeStyledButton(title: "Code For This Modal", action: #selector(toggleCodeView))
        let openInBrowserButton = makeStyledButton(title: "Open in Browser", action: #selector(openInBrowser))
        
        // StackView to layout buttons horizontally
        let buttonStack = UIStackView(arrangedSubviews: [closeButton, selfCodeButton, openInBrowserButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)
        
        // WebView
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        // Load JSON
        loadURLsFromJSON()
        
        if let key = fileKey, let urlString = codeURLs[key], let url = URL(string: urlString) {
            loadCodeFromURL(url)
        } else {
            print("Error: No URL found for the provided key")
        }
        
        // Constraints
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStack.heightAnchor.constraint(equalToConstant: 44),
            
            webView.topAnchor.constraint(equalTo: buttonStack.bottomAnchor, constant: 16),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func makeStyledButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc func toggleCodeView() {
        if isShowingOwnCode {
            // Go back to original code
            if let key = originalFileKey, let urlString = codeURLs[key], let url = URL(string: urlString) {
                loadCodeFromURL(url)
                selfCodeButton.setTitle("Code For This Modal", for: .normal)
                isShowingOwnCode = false
            }
        } else {
            // Show this modal's own code
            let key = "CodeViewController"
            if let urlString = codeURLs[key], let url = URL(string: urlString) {
                loadCodeFromURL(url)
                selfCodeButton.setTitle("Previous Code", for: .normal)
                isShowingOwnCode = true
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let viewportScript = """
        var meta = document.createElement('meta');
        meta.setAttribute('name', 'viewport');
        meta.setAttribute('content', 'width=device-width, initial-scale=1.0');
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        webView.evaluateJavaScript(viewportScript, completionHandler: nil)
    }
    
    @objc func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openInBrowser() {
        let currentKey = isShowingOwnCode ? "CodeViewController" : originalFileKey
        if let key = currentKey, let urlString = codeURLs[key], let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else {
            print("Error: Unable to open URL for current code view")
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

protocol CodeShowable {
    var codeKey: String { get }
}
