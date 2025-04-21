//
//  AboutGameView.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//

import SwiftUI

struct AboutGameView: View {
    var title: String

    var body: some View {
        VStack {
            Text("Welcome to \(title)")
                .font(.largeTitle)
                .padding()

            Text("Here's your SwiftUI content.")
                .padding()
        }
        .navigationTitle(title)
    }
}

