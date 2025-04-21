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
    private var seenModalTypes: Set<String> = []

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
            } else {
                print("no nodes 1")
            }
        } else {
            print("no nodes")
        }
    }

    func advance(to id: String) {
        currentNode = nodes[id]
    }

    // Get choices dynamically based on the nodes that have not been seen yet
    public func getRandomChoices() -> [VentureChoice] {
        // Fetch available nodes that haven't been seen
        let availableNodes = nodes.filter { !seenModalTypes.contains($0.key) }.map { $0.value }

        // Now, build choices for each of those nodes. Here we're assuming each node should generate choices for the next step
        var potentialChoices: [VentureChoice] = []

        for node in availableNodes {
            // Assuming you want to pick random choices from available nodes
            let choice = VentureChoice(title: "Go to \(node.id)", nextNodeID: node.id, modalType: .none, prettyText: node.prettyText)
            potentialChoices.append(choice)
        }

        // Filter out any seen modal types
        let availableChoices = potentialChoices.filter { !seenModalTypes.contains($0.modalType.rawValue) }
        
        // If there are fewer than 2 available choices, include all potential choices
        let randomChoices = availableChoices.shuffled().prefix(2)
        
        // Mark the modal types of chosen nodes as seen
        for choice in randomChoices {
            seenModalTypes.insert(choice.modalType.rawValue)
        }
        
        return Array(randomChoices)
    }
}
