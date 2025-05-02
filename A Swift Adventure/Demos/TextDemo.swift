//
//  TextDemo.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

//
//  TextDemo.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import SwiftUI

@objc class TextDemo: NSObject, WidgetDemo {
    var title: String { "TextDemo" }
    var instructions: String { "Use the segments for dynamic changes" }

    private var plainTextLabel: UILabel!
    private var styledTextLabel: UILabel!

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

        let fontSegmentedControl = UISegmentedControl(items: ["System", "Bold", "Italic"])
        fontSegmentedControl.selectedSegmentIndex = 0
        fontSegmentedControl.addTarget(self, action: #selector(fontChanged(_:)), for: .valueChanged)

        let textColorLabel = UILabel()
        textColorLabel.text = "Text Color"
        textColorLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textColorLabel.textAlignment = .center

        let fontLabel = UILabel()
        fontLabel.text = "Font Style"
        fontLabel.font = UIFont.boldSystemFont(ofSize: 16)
        fontLabel.textAlignment = .center
        
        // Stack for Text Color Label and Segmented Control
        let textColorStack = UIStackView(arrangedSubviews: [textColorLabel, textColorSegmentedControl])
        textColorStack.axis = .horizontal
        textColorStack.spacing = 8
        textColorStack.alignment = .center

        // Stack for Background Color Label and Segmented Control
        let FontStyleStack = UIStackView(arrangedSubviews: [fontLabel, fontSegmentedControl])
        FontStyleStack.axis = .horizontal
        FontStyleStack.spacing = 8
        FontStyleStack.alignment = .center
        
        // Divider Line
        let divider = UIView()
        divider.backgroundColor = .black
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 300).isActive = true

        plainTextLabel = UILabel()
        plainTextLabel.text = "Plain Text"
        plainTextLabel.textAlignment = .center
        plainTextLabel.font = UIFont.systemFont(ofSize: 16)
        plainTextLabel.textColor = .blue

        styledTextLabel = UILabel()
        styledTextLabel.text = "Styled Text"
        styledTextLabel.textAlignment = .center
        styledTextLabel.font = UIFont.systemFont(ofSize: 16)
        styledTextLabel.textColor = .blue

        [textColorStack,FontStyleStack, divider, plainTextLabel, styledTextLabel].forEach {
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
        AnyView(TextDemoSwiftUIView())
    }

    @objc func textColorChanged(_ sender: UISegmentedControl) {
        let selectedColor: UIColor
        switch sender.selectedSegmentIndex {
        case 0: selectedColor = .blue
        case 1: selectedColor = .black
        case 2: selectedColor = .green
        default: selectedColor = .blue
        }
        updateTextColors(textColor: selectedColor)
    }

    @objc func fontChanged(_ sender: UISegmentedControl) {
        let selectedFont: UIFont
        switch sender.selectedSegmentIndex {
        case 0: selectedFont = UIFont.systemFont(ofSize: 16)
        case 1: selectedFont = UIFont.boldSystemFont(ofSize: 16)
        case 2: selectedFont = UIFont.italicSystemFont(ofSize: 16)
        default: selectedFont = UIFont.systemFont(ofSize: 16)
        }
        updateFontStyle(font: selectedFont)
    }

    func updateTextColors(textColor: UIColor) {
        plainTextLabel.textColor = textColor
        styledTextLabel.textColor = textColor
    }

    func updateFontStyle(font: UIFont) {
        styledTextLabel.font = font
    }
}

struct TextDemoSwiftUIView: View {
    @State private var selectedTextColor: Color = .blue  // State for Text Color
    @State private var selectedFont: Font = .body  // State for Font Style
    @State private var alertMessage: String?

    var body: some View {
        VStack(spacing: 16) {
            // Text Color Segment Control with Label
            HStack {
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
            }

            HStack {
                // Font Style Segment Control with Label
                Text("Font Style")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                Picker("Font Style", selection: $selectedFont) {
                    Text("System").tag(Font.body)
                    Text("Bold").tag(Font.title)
                    Text("Italic").tag(Font.body.italic())
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 250) // Matching width of UIKit segments
            }
            
            Divider()
            
            // Plain Text Label with Text Color Binding
            Text("Plain Text")
                .font(.body)
                .foregroundColor(selectedTextColor) // Text color binding

            // Styled Text Label with Font and Text Color Binding
            Text("Styled Text")
                .font(selectedFont)
                .foregroundColor(selectedTextColor) // Text color binding

            Spacer()
        }
        .padding()
        .alert(item: $alertMessage) { msg in
            Alert(title: Text(msg))
        }
    }
}

