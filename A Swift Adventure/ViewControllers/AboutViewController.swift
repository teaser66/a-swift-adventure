//
//  AboutViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit
import SwiftUI

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CodeShowable {
    var codeKey: String { return "AboutViewController" }
    
    let sectionTitles = ["About", "GitHub", "All Files"]

    let tableView = UITableView(frame: .zero, style: .grouped)
    var codeFileKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupTableView()
        loadCodeFileKeys()
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func loadCodeFileKeys() {
        guard let url = Bundle.main.url(forResource: "CodeFiles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: String] else {
            print("Failed to load or parse CodeFiles.json")
            return
        }

        self.codeFileKeys = dict.keys.sorted()
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 3
        case 2:
            return codeFileKeys.count
        default:
            return 0
        }

    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "About the author"
                cell.accessoryType = .disclosureIndicator
            case 1:
                cell.textLabel?.text = "About the game"
                cell.accessoryType = .disclosureIndicator
            default:
                cell.textLabel?.text = ""
            }
        }  else if indexPath.section == 1{
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "View The Project On GitHub"
            case 1:
                cell.textLabel?.text = "Copy the Github Link"
            case 2:
                cell.textLabel?.text = "Share the Github Link"
            default:
                cell.textLabel?.text = ""
            }
        }else if indexPath.section == 2{
            cell.textLabel?.text = codeFileKeys[indexPath.row]
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let aboutVC = AuthorViewController()
                navigationController?.pushViewController(aboutVC, animated: true)
            case 1:
                let swiftUIView = AboutGameView(title: "The Game")
                 let hostingVC = SwiftUICodeWrapper(rootView: swiftUIView, codeKey: "AboutGameView")
                 navigationController?.pushViewController(hostingVC, animated: true)
            default:
                print("Invalid row")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                if let url = URL(string: "https://github.com/teaser66/a-swift-adventure") {
                    UIApplication.shared.open(url)
                } else {
                    print("Invalid URL")
                }
            case 1:
                let text = "https://github.com/teaser66/a-swift-adventure"
                UIPasteboard.general.string = text

                    let alert = UIAlertController(title: "Copied!", message: "\"\(text)\" has been copied to the clipboard.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
            case 2:
                guard let url = URL(string: "https://github.com/teaser66/a-swift-adventure") else { return }
                    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)

                    // iPad support (avoids crashes on iPad)
                    if let popover = activityVC.popoverPresentationController {
                        popover.sourceView = self.view
                        popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popover.permittedArrowDirections = []
                    }

                    present(activityVC, animated: true)
            default:
                print("nothing")
            }
        } else {
            let key = codeFileKeys[indexPath.row]

            guard let topVC = UIApplication.shared.topViewController(),
                  let _ = topVC as? CodeShowable else {
                print("No view controller or doesn't conform to CodeShowable")
                return
            }

            let modal = CodeViewController()
            modal.fileKey = key
            topVC.present(modal, animated: true, completion: nil)
        }
    }
}
