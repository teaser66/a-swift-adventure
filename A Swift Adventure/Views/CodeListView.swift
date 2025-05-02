//
//  CodeListView.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/22/25.
//

import SwiftUI

struct CodeListView: View {
    let fileKeys: [String]
    @Environment(\.presentationMode) var presentationMode
    @State private var isModalPresented = false
    @State private var selectedFileKey: String? = nil

    var body: some View {
        NavigationView {
            List(fileKeys, id: \.self) { key in
                Button(action: {
                    
                    // Set the selected file key
                    selectedFileKey = key
                    
                    // Toggle the modal presentation flag
                    isModalPresented = true
                }) {
                    Text(key)
                }
            }
            .navigationTitle("Select Code File")
            .sheet(isPresented: $isModalPresented) {
                if let fileKey = selectedFileKey {
                    CodeViewControllerWrapper(fileKey: fileKey)
                } else {
                    // If no fileKey is selected, display a fallback message
                    Text("No file selected")
                }
            }
            .onChange(of: selectedFileKey) { _, newValue in
                print("selectedFileKey changed to: \(newValue ?? "nil")")
            }
        }
    }
}




