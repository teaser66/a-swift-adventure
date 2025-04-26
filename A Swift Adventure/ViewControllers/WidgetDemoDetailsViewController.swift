import UIKit

class WidgetDemoDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CodeShowable {
    var codeKey: String { return "WidgetDemoDetailsViewController" }
    
    let files: [String] = [
        "WidgetDemoProtocol",
        "WidgetRegistry"
    ]
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Widget Demo Details"
        view.backgroundColor = .systemBackground

        let headerLabel = UILabel()
        headerLabel.text = "Behind the scenes of the widget demos:\n\nEach demo follows the WidgetDemoProtocol, ensuring a consistent interface.\n\nThe WidgetRegistry is just a curated list of widgets to showcase.\n\nIt all comes together in this:\nWidgetDetailsViewController.\n\nTap \"Code\" in the corner to see how this screen works.\n\nTap the files below to see their code."
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        headerLabel.numberOfLines = 0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerLabel)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            // Ensure headerLabel respects safe area at the top
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            // Space out the tableView from the headerLabel
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
        //cell.accessoryType = .disclosureIndicator
        //cell.detailTextLabel?.text = "test"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let topVC = UIApplication.shared.topViewController(),
              let _ = topVC as? CodeShowable else {
            print("No view controller or doesn't conform to CodeShowable")
            return
        }

        let modal = CodeViewController()
        
        // Handle selection for code view based on file selection
        switch indexPath.row {
        case 0:
            modal.fileKey = "WidgetDemoProtocol"
        case 1:
            modal.fileKey = "WidgetRegistry"
        default:
            modal.fileKey = ""
        }
        
        topVC.present(modal, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
