//
//  BrowseViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit

class BrowseViewController: UITableViewController, CodeShowable {
    var codeKey: String { return "BrowseViewController" }

    private let widgets = WidgetRegistry.allWidgets

    enum Section: Int, CaseIterable {
        case info
        case widgets
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Widgets"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .info:
            return 1
        case .widgets:
            return widgets.count
        case .none:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section) {
        case .info:
            return "About Widget Demos"
        case .widgets:
            return "All Widgets"
        case .none:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        switch Section(rawValue: indexPath.section) {
        case .info:
            cell.textLabel?.text = "How Widget Demos Work"
            cell.accessoryType = .disclosureIndicator
        case .widgets:
            let demo = widgets[indexPath.row]
            var title = demo.title
            title = title.replacingOccurrences(of: "demo", with: "", options: .caseInsensitive)
            cell.textLabel?.text = title
            cell.accessoryType = .disclosureIndicator
        case .none:
            break
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) {
        case .info:
            let vc = WidgetDemoDetailsViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .widgets:
            let demo = widgets[indexPath.row]
            let vc = WidgetShowcaseViewController(demo: demo)
            navigationController?.pushViewController(vc, animated: true)
        case .none:
            break
        }
    }
}

