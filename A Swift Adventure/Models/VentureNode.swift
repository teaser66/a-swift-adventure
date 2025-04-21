//
//  VentureNode.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

struct VentureNode: Identifiable, Codable {
    let id: String
    let imageName: String
    let text: String
    let choices: [VentureChoice]?
    let prettyText: String
}

struct VentureChoice: Codable {
    let title: String
    let nextNodeID: String
    let modalType: ModalType
    let prettyText: String
}

enum ModalType: String, Codable {
    case takePicture
    case getCameraRoll
    case saveToPhotos
    case editImage
    case recordVideo
    case recordAudio
    case playMusic
    case getAPI
    case postAPI
    case cacheImage
    case parseJSON
    case combineURLSession
    case coreData
    case userDefaults
    case fileManager
    case keychain
    case formFun
    case themes
    case animations
    case getLocation
    case mapkit
    case localNotifications
    case haptic
    case arKit
    case none
}

