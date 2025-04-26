//
//  GameActionViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/21/25.
//


import UIKit
import SwiftUI

class GameActionViewController: UIViewController, CodeShowable {
    var codeKey: String { "GameActionViewController" }
    var incomingAction: ModalType

    init(incomingAction: ModalType) {
        self.incomingAction = incomingAction
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupResetButton()

        let contentView = ActionContentView(action: incomingAction)
        let hostingController = UIHostingController(rootView: contentView)

        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }

    private func setupResetButton() {
        let resetButton = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(showResetAlert))
        navigationItem.leftBarButtonItem = resetButton
    }

    @objc private func showResetAlert() {
        let alert = UIAlertController(title: "Restart Adventure?", message: "Are you sure you want to reset?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            VentureEngine().reset()
            self.navigationController?.popToRootViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

struct ActionContentView: View {
    var action: ModalType
    @State private var showCodeList = false

    var body: some View {
            contentView()
    }

    @ViewBuilder
    private func contentView() -> some View {
        switch action {
        case .arKit:
            ARView()
        case .animations:
            AnimationsView()
        case .cacheImage:
            CacheImageView()
        case .getAPI:
            APICallView()
        case .getCameraRoll:
            CameraRollView()
        case .combineURLSession:
            CombineView()
        case .coreData:
            CoreDataView()
        case .editImage:
            EditImageView()
        case .fileManager:
            FileManagerView()
        case .formFun:
            FormView()
        case .haptic:
            HapticView()
        case .keychain:
            KeychainView()
        case .getLocation:
            LocationView()
        case .mapkit:
            MapView()
        case .localNotifications:
            NotificationsView()
        case .parseJSON:
            ParseJSONView()
        case .playMusic:
            PlayMusicView()
        case .postAPI:
            PostAPIView()
        case .recordAudio:
            RecordAudioView()
        case .recordVideo:
            RecordVideoView()
        case .saveToPhotos:
            SavePhotoView()
        case .takePicture:
            TakePictureView()
        case .themes:
            ThemesView()
        case .userDefaults:
            UserDefaultsView()
        case .none:
            Text("No action provided.")
        }
    }

    private func fileKeysFor(_ action: ModalType) -> [String] {
        switch action {
        case .arKit:
            return ["arKit"]
        case .animations:
            return ["animations"]
        case .cacheImage:
            return ["cacheImage"]
        case .getAPI:
            return ["getAPI"]
        case .getCameraRoll:
            return ["getCameraRoll"]
        case .combineURLSession:
            return ["combineURLSession"]
        case .coreData:
            return ["coreData"]
        case .editImage:
            return ["editImage"]
        case .fileManager:
            return ["fileManager"]
        case .formFun:
            return ["formFun"]
        case .haptic:
            return ["haptic"]
        case .keychain:
            return ["keychain"]
        case .getLocation:
            return ["getLocation"]
        case .mapkit:
            return ["mapkit"]
        case .localNotifications:
            return ["localNotifications"]
        case .parseJSON:
            return ["parseJSON"]
        case .playMusic:
            return ["playMusic", "MusicManager", "AudioEngine"]
        case .postAPI:
            return ["postAPI"]
        case .recordAudio:
            return ["recordAudio"]
        case .recordVideo:
            return ["recordVideo"]
        case .saveToPhotos:
            return ["saveToPhotos"]
        case .takePicture:
            return ["takePicture"]
        case .themes:
            return ["themes"]
        case .userDefaults:
            return ["userDefaults"]
        case .none:
            return []
        }
    }
}
