//
//  ButtonDemo.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import SwiftUI

@objc class ButtonDemo: NSObject, WidgetDemo {
    var title: String { "Button" }
    var instructions: String { "Use the segments for dynamic changes" }

    private var plainButton: UIButton!
    private var coloredButton: UIButton!

    func makeUIKitView() -> UIView {
        let container = UIView()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let textColorSegmentedControl = UISegmentedControl(items: ["Blue", "Black", "Green"])
        textColorSegmentedControl.selectedSegmentIndex = 0
        textColorSegmentedControl.addTarget(self, action: #selector(textColorChanged(_:)), for: .valueChanged)

        let backgroundColorSegmentedControl = UISegmentedControl(items: ["Blue", "Red", "Purple"])
        backgroundColorSegmentedControl.selectedSegmentIndex = 0
        backgroundColorSegmentedControl.addTarget(self, action: #selector(backgroundColorChanged(_:)), for: .valueChanged)

        let textColorLabel = UILabel()
        textColorLabel.text = "Text Color"
        textColorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textColorLabel.textAlignment = .center

        let backgroundColorLabel = UILabel()
        backgroundColorLabel.text = "Background Color"
        backgroundColorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        backgroundColorLabel.textAlignment = .center

        plainButton = UIButton(type: .system)
        plainButton.setTitle("Plain Button", for: .normal)
        plainButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        plainButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        plainButton.addAction(UIAction { _ in
            self.showAlert(title: "I am a plain button")
        }, for: .touchUpInside)

        coloredButton = UIButton(type: .system)
        coloredButton.setTitle("Colored Button", for: .normal)
        coloredButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        coloredButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        coloredButton.backgroundColor = .systemBlue
        coloredButton.setTitleColor(.white, for: .normal)
        coloredButton.layer.cornerRadius = 8
        coloredButton.addAction(UIAction { _ in
            self.showAlert(title: "I am a colored button")
        }, for: .touchUpInside)

        let multiline = UIButton(type: .system)
        multiline.setTitle("Multiline\nButton", for: .normal)
        multiline.widthAnchor.constraint(equalToConstant: 150).isActive = true
        multiline.heightAnchor.constraint(equalToConstant: 44).isActive = true
        multiline.titleLabel?.numberOfLines = 2
        multiline.titleLabel?.textAlignment = .center
        multiline.addAction(UIAction { _ in
            self.showAlert(title: "I am a multiline button")
        }, for: .touchUpInside)

        [textColorLabel, textColorSegmentedControl, plainButton, backgroundColorLabel, backgroundColorSegmentedControl, coloredButton, multiline].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview($0)
        }

        container.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    func makeSwiftUIView() -> AnyView {
        AnyView(ButtonDemoSwiftUIView())
    }

    private func showAlert(title: String) {
        guard let topVC = UIApplication.shared.topViewController() else { return }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        topVC.present(alert, animated: true)
    }

    @objc func textColorChanged(_ sender: UISegmentedControl) {
        let selectedColor: UIColor
        switch sender.selectedSegmentIndex {
        case 0: selectedColor = .blue
        case 1: selectedColor = .black
        case 2: selectedColor = .green
        default: selectedColor = .blue
        }
        updateButtonColors(textColor: selectedColor)
    }

    @objc func backgroundColorChanged(_ sender: UISegmentedControl) {
        let selectedColor: UIColor
        switch sender.selectedSegmentIndex {
        case 0: selectedColor = .blue
        case 1: selectedColor = .red
        case 2: selectedColor = .purple
        default: selectedColor = .blue
        }
        updateButtonBackgroundColor(backgroundColor: selectedColor)
    }

    func updateButtonColors(textColor: UIColor) {
        plainButton.setTitleColor(textColor, for: .normal)
    }

    func updateButtonBackgroundColor(backgroundColor: UIColor) {
        coloredButton.backgroundColor = backgroundColor
    }
}

struct ButtonDemoSwiftUIView: View {
    @State private var alertMessage: String?
    @State private var selectedTextColor: Color = .blue  // State for Text Color
    @State private var selectedBackgroundColor: Color = .blue // State for Background Color
    
    var body: some View {
        VStack(spacing: 16) {
            // Text Color Segment Control with Label
            Text("Text Color")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            Picker("Text Color", selection: $selectedTextColor) {
                Text("Blue").tag(Color.blue)
                Text("Black").tag(Color.black)
                Text("Green").tag(Color.green)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 250) // Matching width of UIKit segments
            .padding(.horizontal, 32)

            // Plain Button with Text Color Binding
            Button("Plain Button") {
                alertMessage = "I am a plain button"
            }
            .padding()
            .frame(width: 150, height: 44)  // Exact button size as UIKit
            .foregroundColor(selectedTextColor) // Text color binding
            .background(Color.clear) // No background color
            .cornerRadius(0) // No rounded corners, flat style

            // Background Color Segment Control with Label
            Text("Background Color")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .center)
            Picker("Background Color", selection: $selectedBackgroundColor) {
                Text("Blue").tag(Color.blue)
                Text("Red").tag(Color.red)
                Text("Purple").tag(Color.purple)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 250) // Matching width of UIKit segments
            .padding(.horizontal, 32)

            // Colored Button with Background Color Binding
            Button("Colored Button") {
                alertMessage = "I am a colored button"
            }
            .padding()
            .frame(width: 150, height: 44)  // Exact button size as UIKit
            .background(selectedBackgroundColor) // Background color binding
            .foregroundColor(.white)  // Text color white for visibility
            .cornerRadius(8)  // Rounded corners for colored button

            // Multiline Button
            Button("Multiline\nButton") {
                alertMessage = "I am a multiline button"
            }
            .frame(width: 150, height: 44) // Exact button size as UIKit
            .multilineTextAlignment(.center)
            .padding()

            Spacer()
        }
        .padding()
        .alert(item: $alertMessage) { msg in
            Alert(title: Text(msg))
        }
    }
}
