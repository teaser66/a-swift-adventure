//
//  CodeOverlayManager.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class CodeOverlayManager {
    static let shared = CodeOverlayManager()
    private var button: UIButton?

    func setupButton(in window: UIWindow) {
        guard button == nil else { return } // already added
        
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

        let modal = CodeViewController()
        modal.fileKey = codeVC.codeKey
        topVC.present(modal, animated: true, completion: nil)
    }
}

