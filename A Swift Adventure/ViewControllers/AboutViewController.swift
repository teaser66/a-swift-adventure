//
//  AboutViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

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
        return section == 2 ? codeFileKeys.count : 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "About the author"
            cell.accessoryType = .disclosureIndicator
        }  else if indexPath.section == 1{
            cell.textLabel?.text = "View The Project On GitHub"
        }else if indexPath.section == 2{
            cell.textLabel?.text = codeFileKeys[indexPath.row]
        }

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            let aboutVC = AuthorViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        } else if indexPath.section == 1 {
            if let url = URL(string: "https://github.com/teaser66/a-swift-adventure") {
                UIApplication.shared.open(url)
            } else {
                print("Invalid URL")
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
