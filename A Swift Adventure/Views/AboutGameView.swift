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
        "VentureNode"
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Welcome to \(title)")
                .font(.largeTitle)
                .padding([.top, .horizontal])

            Text("Learn about how each part of the engine works:")
                .font(.headline)
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
