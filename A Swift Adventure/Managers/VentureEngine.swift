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
    private var seenNodeIDs: Set<String> = []

    init() {
        loadNodes()
        if let start = nodes["start"] {
            currentNode = start
            seenNodeIDs.insert(start.id)
        }
    }

    private func loadNodes() {
        guard let url = Bundle.main.url(forResource: "nodes", withExtension: "json") else {
            print("No nodes file found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([VentureNode].self, from: data)
            for node in decoded {
                nodes[node.id] = node
            }
        } catch {
            print("Failed to load or decode nodes: \(error)")
        }
    }

    @discardableResult
    func advance(to id: String) -> VentureNode? {
        if let next = nodes[id] {
            currentNode = next
            seenNodeIDs.insert(next.id)
            return next
        }
        return nil
    }

    func getChoices() -> [VentureChoice] {
        return currentNode?.choices ?? []
    }

    func getRandomChoices(limit: Int = 2) -> [VentureChoice] {
        // Only show nodes that haven't been visited yet
        let unseenNodes = nodes.values.filter { !seenNodeIDs.contains($0.id) }

        let choices = unseenNodes.map { node in
            // Ensure that prettyText is never nil, use a fallback if necessary
            let choiceText = node.prettyText.isEmpty ? "Go to \(node.id)" : node.prettyText
            return VentureChoice(title: choiceText, nextNodeID: node.id, modalType: .none, prettyText: choiceText)
        }

        return Array(choices.shuffled().prefix(limit))
    }
}
