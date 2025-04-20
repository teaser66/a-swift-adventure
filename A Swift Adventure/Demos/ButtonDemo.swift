//
//  ButtonDemo.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import SwiftUI

@objc class ButtonDemo: NSObject, WidgetDemo {
    var title: String { "ButtonDemo" }
    var instructions: String { "Use the segments for dynamic changes" }

    private var plainButton: UIButton!
    private var coloredButton: UIButton!
    private var multilineButton: UIButton!

    func makeUIKitView() -> UIView {
        let container = UIView()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        let textColorSegmentedControl = UISegmentedControl(items: ["Black", "Yellow", "Cyan"])
        textColorSegmentedControl.selectedSegmentIndex = 0
        textColorSegmentedControl.addTarget(self, action: #selector(textColorChanged(_:)), for: .valueChanged)

        let backgroundColorSegmentedControl = UISegmentedControl(items: ["Gray", "Indigo", "Orange"])
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
        plainButton.setTitleColor(.black, for: .normal)
        plainButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        plainButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        plainButton.addAction(UIAction { _ in
            self.showAlert(title: "I am a plain button")
        }, for: .touchUpInside)

        coloredButton = UIButton(type: .system)
        coloredButton.setTitle("Colored Button", for: .normal)
        coloredButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        coloredButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        coloredButton.backgroundColor = .darkGray
        coloredButton.setTitleColor(.black, for: .normal)
        coloredButton.layer.cornerRadius = 8
        coloredButton.addAction(UIAction { _ in
            self.showAlert(title: "I am a colored button")
        }, for: .touchUpInside)

        multilineButton = UIButton(type: .system)
        multilineButton.setTitle("Multiline\nButton", for: .normal)
        multilineButton.setTitleColor(.black, for: .normal)
        multilineButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        multilineButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        multilineButton.titleLabel?.numberOfLines = 2
        multilineButton.titleLabel?.textAlignment = .center
        multilineButton.addAction(UIAction { _ in
            self.showAlert(title: "I am a multiline button")
        }, for: .touchUpInside)

        // Stack for Text Color Label and Segmented Control
        let textColorStack = UIStackView(arrangedSubviews: [textColorLabel, textColorSegmentedControl])
        textColorStack.axis = .horizontal
        textColorStack.spacing = 8
        textColorStack.alignment = .center

        // Stack for Background Color Label and Segmented Control
        let backgroundColorStack = UIStackView(arrangedSubviews: [backgroundColorLabel, backgroundColorSegmentedControl])
        backgroundColorStack.axis = .horizontal
        backgroundColorStack.spacing = 8
        backgroundColorStack.alignment = .center

        // Divider Line
        let divider = UIView()
        divider.backgroundColor = .black
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 300).isActive = true

        // Add everything to the main stack
        [textColorStack, backgroundColorStack, divider, plainButton, coloredButton, multilineButton].forEach {
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
        case 0: selectedColor = .black
        case 1: selectedColor = .systemYellow
        case 2: selectedColor = .cyan
        default: selectedColor = .black
        }
        updateButtonColors(textColor: selectedColor)
    }

    @objc func backgroundColorChanged(_ sender: UISegmentedControl) {
        let selectedColor: UIColor
        switch sender.selectedSegmentIndex {
        case 0: selectedColor = .darkGray
        case 1: selectedColor = .systemIndigo
        case 2: selectedColor = .orange
        default: selectedColor = .darkGray
        }
        updateButtonBackgroundColor(backgroundColor: selectedColor)
    }

    func updateButtonColors(textColor: UIColor) {
        plainButton.setTitleColor(textColor, for: .normal)
        coloredButton.setTitleColor(textColor, for: .normal)
        multilineButton.setTitleColor(textColor, for: .normal)
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
            // Text Color Segment Control with Label (Inline)
            HStack {
                Text("Text Color")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("Text Color", selection: $selectedTextColor) {
                    Text("Black").tag(Color.black)
                    Text("Yellow").tag(Color.yellow)
                    Text("Cyan").tag(Color.cyan)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 250)
            }
            
            // Background Color Segment Control with Label (Inline)
            HStack {
                Text("Background Color")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Picker("Background Color", selection: $selectedBackgroundColor) {
                    Text("Gray").tag(Color.gray)
                    Text("Indigo").tag(Color.purple)
                    Text("Orange").tag(Color.orange)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 250)
            }

            // Divider Line
            Divider().frame(height: 1).background(Color.black)

            // Plain Button with Text Color Binding
            Button("Plain Button") {
                alertMessage = "I am a plain button"
            }
            .padding()
            .frame(width: 150, height: 44)
            .foregroundColor(selectedTextColor)
            .background(Color.clear)
            .cornerRadius(0)

            // Colored Button with Background and Text Color Binding
            Button("Colored Button") {
                alertMessage = "I am a colored button"
            }
            .padding()
            .frame(width: 150, height: 44)
            .background(selectedBackgroundColor)
            .foregroundColor(selectedTextColor)
            .cornerRadius(8)

            // Multiline Button with Text Color Binding
            Button("Multiline\nButton") {
                alertMessage = "I am a multiline button"
            }
            .frame(width: 150, height: 44)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(selectedTextColor)

            Spacer()
        }
        .padding()
        .alert(item: $alertMessage) { msg in
            Alert(title: Text(msg))
        }
    }
}
