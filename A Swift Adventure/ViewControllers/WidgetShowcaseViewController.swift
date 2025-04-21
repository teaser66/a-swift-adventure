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

    private static func savedFramework() -> FrameworkType {
        let saved = UserDefaults.standard.string(forKey: "preferredFramework")
        return FrameworkType(rawValue: saved ?? "") ?? .uikit
    }

    private let segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["UIKit", "SwiftUI"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private let codeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .label
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return textView
    }()

    private let contentView = UIView()

    init(demo: WidgetDemo) {
        self.demo = demo
        self.currentFramework = WidgetShowcaseViewController.savedFramework()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = demo.title.replacingOccurrences(of: "demo", with: "", options: .caseInsensitive)

        setupLayout()
        updateContent()
        instructionsTextView.text = demo.instructions
    }

    private func setupLayout() {
        segment.selectedSegmentIndex = currentFramework == .uikit ? 0 : 1
        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        codeButton.setTitle("Code For This \(demo.title) Widget", for: .normal)
        codeButton.addTarget(self, action: #selector(showWidgetCode), for: .touchUpInside)

        view.addSubview(segment)
        view.addSubview(codeButton)
        view.addSubview(instructionsTextView)
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            codeButton.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 8),
            codeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            instructionsTextView.topAnchor.constraint(equalTo: codeButton.bottomAnchor, constant: 16),
            instructionsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            contentView.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        let selected = sender.selectedSegmentIndex == 0 ? FrameworkType.uikit : FrameworkType.swiftui
        guard selected != currentFramework else { return }

        UIView.transition(with: contentView, duration: 0.3, options: .transitionCrossDissolve) {
            self.currentFramework = selected
        }
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

            guard let hostedView = host.view else { return }
            hostedView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostedView)

            NSLayoutConstraint.activate([
                hostedView.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                hostedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])

            host.didMove(toParent: self)
        }
    }

    @objc private func showWidgetCode() {
        guard let topVC = UIApplication.shared.topViewController(),
              let _ = topVC as? CodeShowable else {
            print("No view controller or doesn't conform to CodeShowable")
            return
        }

        let modal = CodeViewController()
        modal.fileKey = demo.title.replacingOccurrences(of: " ", with: "")
        topVC.present(modal, animated: true)
    }

}
