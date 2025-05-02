//
//  CodeOverlayManager.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

import UIKit
import SwiftUI

class CodeOverlayManager {
    static let shared = CodeOverlayManager()
    private var button: UIButton?

    func setupButton(in window: UIWindow) {
        guard button == nil else { return }
        
        let btn = UIButton(type: .system)
        btn.setTitle("Code", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 15
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        window.addSubview(btn)
        window.bringSubviewToFront(btn)

        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 0),
            btn.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -10),
            btn.widthAnchor.constraint(equalToConstant: 60),
            btn.heightAnchor.constraint(equalToConstant: 30)
        ])

        self.button = btn
    }

    @objc private func buttonTapped() {
        guard let topVC = UIApplication.shared.topViewController(),
              let codeVC = topVC as? CodeShowable else {
            print("No view controller or doesn't conform to CodeShowable")
            return
        }

        // Check if the codeKey is "GameActionViewController"
        if codeVC.codeKey == "GameActionViewController" {
            // Slide into CodeListView (SwiftUI)
            let gavc = codeVC as? GameActionViewController
            let incomingAction = gavc?.incomingAction ?? .none
            let fileKeys = fileKeysFor(incomingAction)
            let codeListView = CodeListView(fileKeys: fileKeys)
            let hostingController = SwiftUICodeWrapper(rootView: codeListView, codeKey: "CodeListView")
            // Push the hosting controller onto the navigation stack
            if let navController = topVC.navigationController {
                navController.pushViewController(hostingController, animated: true)
            } else {
                print("No navigation controller found.")
            }
        } else {
            // Continue with the modal presentation
            let modal = CodeViewController()
            modal.fileKey = codeVC.codeKey
            topVC.present(modal, animated: true, completion: nil)
        }
    }

    private func fileKeysFor(_ modalType: ModalType) -> [String] {
        // Return different file keys based on the modal type
        switch modalType {
        case .takePicture:
            return ["takePicture", "takePicture1"]
        case .getCameraRoll:
            return ["cameraRoll", "cameraRoll1"]
        case .saveToPhotos:
            return ["saveToPhotos", "saveToPhotos1"]
        case .editImage:
            return ["editImage", "editImage1"]
        case .recordVideo:
            return ["recordVideo", "recordVideo1"]
        case .recordAudio:
            return ["recordAudio", "recordAudio1"]
        case .playMusic:
            return ["gameAction", "gameAction1"]
        case .getAPI:
            return ["getAPI", "getAPI1"]
        case .postAPI:
            return ["postAPI", "postAPI1"]
        case .cacheImage:
            return ["cacheImage", "cacheImage1"]
        case .parseJSON:
            return ["parseJSON", "parseJSON1"]
        case .combineURLSession:
            return ["combineURLSession", "combineURLSession1"]
        case .coreData:
            return ["coreData", "coreData1"]
        case .userDefaults:
            return ["userDefaults", "userDefaults1"]
        case .fileManager:
            return ["fileManager", "fileManager1"]
        case .keychain:
            return ["keychain", "keychain1"]
        case .formFun:
            return ["formFun", "formFun1"]
        case .themes:
            return ["themes", "themes1"]
        case .animations:
            return ["animations", "animations1"]
        case .getLocation:
            return ["getLocation", "getLocation1"]
        case .mapkit:
            return ["mapkit", "mapkit1"]
        case .localNotifications:
            return ["localNotifications", "localNotifications1"]
        case .haptic:
            return ["haptic", "haptic1"]
        case .arKit:
            return ["arKit", "arKit1"]
        case .none:
            return [] // Default case when no modal type is specified
        }
    }
}
