//
//  WidgetDemoDetailsViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/20/25.
//

import UIKit

class WidgetDemoDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CodeShowable {
    var codeKey: String { return "WidgetDemoDetailsViewController" }
    
    let files: [String] = [
        "WidgetDemoProtocol",
        "WidgetRegistry",
        "WidgetDetailsViewController"
    ]
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Widget Demo Details"
        view.backgroundColor = .systemBackground

        let headerLabel = UILabel()
        headerLabel.text = "This is how the widget demo pages work behind the scenes:"
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = files[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let file = files[indexPath.row]
//        let filePath = "https://github.com/your-repo/A-Swift-Adventure/blob/main/\(file)"
//        let webVC = WebViewController(urlString: filePath) // assuming you have this already
//        present(webVC, animated: true)
    }
}

