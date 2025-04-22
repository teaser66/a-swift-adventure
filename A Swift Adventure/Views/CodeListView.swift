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

    var body: some View {
        NavigationView {
            List(fileKeys, id: \.self) { key in
                NavigationLink(destination: CodeViewControllerWrapper(fileKey: key)) {
                    Text(key)
                }
            }
            .navigationTitle("Select Code File")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
