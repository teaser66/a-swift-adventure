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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Widgets"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return widgets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let demo = widgets[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = demo.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = widgets[indexPath.row]
        let vc = WidgetShowcaseViewController(demo: demo)
        navigationController?.pushViewController(vc, animated: true)
    }
}
