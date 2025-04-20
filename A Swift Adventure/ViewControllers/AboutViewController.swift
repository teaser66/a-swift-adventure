//
//  AboutViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CodeShowable {
    var codeKey: String { return "AboutViewController" }

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
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : codeFileKeys.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "About" : "All Files"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        if indexPath.section == 0 {
            cell.textLabel?.text = "About the author"
            cell.accessoryType = .disclosureIndicator
        } else {
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
