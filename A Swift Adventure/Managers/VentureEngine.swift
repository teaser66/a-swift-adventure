//
//  VentureEngine.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import Foundation

class VentureEngine {
    private var nodes: [String: VentureNode] = [:]
    private(set) var currentNode: VentureNode?

    init() {
        loadNodes()
        currentNode = nodes["start"]
    }

    private func loadNodes() {
        if let url = Bundle.main.url(forResource: "nodes", withExtension: "json") {
            if let data = try? Data(contentsOf: url),
               let decoded = try? JSONDecoder().decode([VentureNode].self, from: data) {
                for node in decoded {
                    nodes[node.id] = node
                }
            }
        }
    }

    func advance(to id: String) {
        currentNode = nodes[id]
    }
}


