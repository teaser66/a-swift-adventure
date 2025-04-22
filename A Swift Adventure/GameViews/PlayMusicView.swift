//
//  PlayMusicView.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//

import SwiftUI

struct PlayMusicView: View {
    var body: some View {
        NavigationView {
            Text("🎵 Now playing music...")
                .font(.title)
                .padding()
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Code For This Action") {
                            showCode()
                        }
                    }
                }
        }
    }

    func showCode() {
        
    }
}
