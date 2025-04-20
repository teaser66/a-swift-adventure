    //
    //  WidgetShowcaseViewController.swift
    //  A Swift Adventure
    //
    //  Created by Rob Faiella on 4/20/25.
    //

    import UIKit
    import SwiftUI

    enum FrameworkType: String {
        case uikit
        case swiftui
    }

    class WidgetShowcaseViewController: UIViewController, CodeShowable {
        
        var codeKey: String { return "WidgetShowcaseViewController" }
        
        private let demo: WidgetDemo
        private var currentFramework: FrameworkType {
            didSet {
                UserDefaults.standard.set(currentFramework.rawValue, forKey: "preferredFramework")
                updateContent()
            }
        }

        private let segment: UISegmentedControl = {
            let control = UISegmentedControl(items: ["UIKit", "SwiftUI"])
            control.selectedSegmentIndex = 0
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
        }()
        
        private let codeButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Code For This Widget", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        private let contentView = UIView()

        init(demo: WidgetDemo) {
            self.demo = demo
            let saved = UserDefaults.standard.string(forKey: "preferredFramework") ?? FrameworkType.uikit.rawValue
            self.currentFramework = FrameworkType(rawValue: saved) ?? .uikit
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .systemBackground
            title = demo.title

            segment.translatesAutoresizingMaskIntoConstraints = false
            codeButton.translatesAutoresizingMaskIntoConstraints = false
            contentView.translatesAutoresizingMaskIntoConstraints = false

            segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
            segment.selectedSegmentIndex = currentFramework == .uikit ? 0 : 1

            codeButton.addTarget(self, action: #selector(showWidgetCode), for: .touchUpInside)

            view.addSubview(segment)
            view.addSubview(codeButton)
            view.addSubview(contentView)

            NSLayoutConstraint.activate([
                segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
                segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                codeButton.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 8),
                codeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                contentView.topAnchor.constraint(equalTo: codeButton.bottomAnchor, constant: 16),
                contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

                contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
            ])

            updateContent()
        }


        @objc private func segmentChanged(_ sender: UISegmentedControl) {
            currentFramework = sender.selectedSegmentIndex == 0 ? .uikit : .swiftui
        }
        
        @objc private func showWidgetCode() {
            guard let topVC = UIApplication.shared.topViewController(),
                    let codeVC = topVC as? CodeShowable else {
                  print("No view controller or doesn't conform to CodeShowable")
                  return
              }

              let modal = CodeViewController()
              
              // Use the demo's title (or any identifier) as the fileKey
              modal.fileKey = demo.title.replacingOccurrences(of: " ", with: "")
              
              topVC.present(modal, animated: true, completion: nil)
        }

        private func updateContent() {
            contentView.subviews.forEach { $0.removeFromSuperview() }
            children.forEach { $0.removeFromParent() }

            switch currentFramework {
            case .uikit:
                let uikitView = demo.makeUIKitView()
                uikitView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(uikitView)
                NSLayoutConstraint.activate([
                    uikitView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    uikitView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    uikitView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
            case .swiftui:
                let swiftUIView = demo.makeSwiftUIView()
                let host = UIHostingController(rootView: swiftUIView)
                addChild(host)

                let hostedView = host.view!
                hostedView.translatesAutoresizingMaskIntoConstraints = false

                contentView.addSubview(hostedView)
                NSLayoutConstraint.activate([
                    hostedView.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                    hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
                
                host.didMove(toParent: self)

                view.setNeedsLayout()
                view.layoutIfNeeded()
            }
        }
    }

