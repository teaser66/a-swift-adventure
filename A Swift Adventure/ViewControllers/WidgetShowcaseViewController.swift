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

class WidgetShowcaseViewController: UIViewController {
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

        segment.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segment.selectedSegmentIndex = currentFramework == .uikit ? 0 : 1

        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(segment)
        view.addSubview(contentView)

        NSLayoutConstraint.activate([
            segment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            contentView.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        updateContent()
    }

    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        currentFramework = sender.selectedSegmentIndex == 0 ? .uikit : .swiftui
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
            host.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(host.view)
            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            host.didMove(toParent: self)
        }
    }
}

