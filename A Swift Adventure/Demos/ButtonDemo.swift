//
//  ButtonDemo.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import UIKit
import SwiftUI

struct ButtonDemo: WidgetDemo {
    var title: String { "Button" }

    func makeUIKitView() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16

        let plain = UIButton(type: .system)
        plain.setTitle("Plain Button", for: .normal)

        let colored = UIButton(type: .system)
        colored.setTitle("Colored Button", for: .normal)
        colored.backgroundColor = .systemBlue
        colored.setTitleColor(.white, for: .normal)
        colored.layer.cornerRadius = 8

        let multiline = UIButton(type: .system)
        multiline.setTitle("Multiline\nButton", for: .normal)
        multiline.titleLabel?.numberOfLines = 2

        [plain, colored, multiline].forEach { stack.addArrangedSubview($0) }
        return stack
    }

    func makeSwiftUIView() -> AnyView {
        AnyView(
            VStack(spacing: 16) {
                Button("Plain Button") {}
                Button("Colored Button") {}
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                Button("Multiline\nButton") {}
                    .multilineTextAlignment(.center)
            }
            .padding()
        )
    }
}

