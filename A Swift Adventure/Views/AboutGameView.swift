//
//  AboutGameView.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//

import SwiftUI

struct AboutGameView: View {
    var title: String

    @State private var selectedItem: String?
    @State private var showingModal = false

    private let items = [
        "VentureEngine",
        "VentureNode",
        "nodes.json"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Welcome to \(title)")
                .font(.largeTitle)
                .padding([.top, .horizontal])
            
            Spacer()

            Text("Learn about how each part of the engine works:")
                .font(.headline)
                .padding(.horizontal)
            
            Spacer()

            Text("Check out the Engine, Node and JSON file below. The Node defines the structure of each choice in the game. \n\nThe Engine randomizes your net choice and tracks where you have been. \n\nAnd the JSON is simply the list of options.\n\nThen the correct SwiftUI view is added to the screen based on your choice.")
                .padding(.horizontal)

            List {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        selectedItem = item
                        showingModal = true
                    }) {
                        HStack {
                            Text(item)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle(title)
        .sheet(item: $selectedItem) { key in
            CodeViewControllerWrapper(fileKey: key)
        }
    }
}
