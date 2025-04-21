//
//  VentureNode.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

struct VentureNode: Codable {
    let id: String
    let imageName: String
    let text: String
    let choices: [VentureChoice]
}

struct VentureChoice: Codable {
    let title: String
    let nextNodeID: String
    let modalType: ModalType?
}

enum ModalType: String, Codable {
    case playMusic
    case callAPI
    case none
}

