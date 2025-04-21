import UIKit
import SwiftUI

class VentureViewController: UIViewController, CodeShowable {
    var codeKey: String { return "VentureViewController" }
    var codeFileKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let ventureView = VentureView()
        let hostingController = UIHostingController(rootView: ventureView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}

// MARK: - SwiftUI Venture View and Supporting Types

struct VentureView: View {
    @StateObject private var engine = VentureEngineWrapper()
    @State private var activeModalTypeRaw: String?

    var body: some View {
        VStack {
            if let node = engine.currentNode {
                Image(node.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)

                Text(node.text)
                    .padding()

                ForEach(node.choices, id: \.title) { choice in
                    Button(action: {
                        if let modal = choice.modalType, modal != .none {
                            activeModalTypeRaw = modal.rawValue
                        }
                        engine.advance(to: choice.nextNodeID)
                    }) {
                        Text(choice.title)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("Game Over")
            }
        }
        .sheet(item: $activeModalTypeRaw) { modalRaw in
            if let modal = ModalType(rawValue: modalRaw) {
                ModalExperienceView(modalType: modal, dismissAction: {
                    // Handle dismiss action, possibly by clearing modal
                    activeModalTypeRaw = nil
                })
            }
        }
    }
}

struct ModalExperienceView: View {
    let modalType: ModalType
    var dismissAction: () -> Void

    var body: some View {
        VStack {
            Button(action: {
                dismissAction()
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white) // Text color
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)  // Solid blue background
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)  // Make sure it takes up full width
            }
            .padding(.top, 50)  // Adjust padding as needed
            
            switch modalType {
            case .playMusic:
                PlayMusicView()
            case .callAPI:
                APICallView()
            case .miniGame:
                MiniGameView()
            case .none:
                EmptyView()
            }
        }
        .padding()
    }
}

// Extend ModalType to work with .sheet
extension ModalType: Identifiable {
    var id: String { self.rawValue }
}

// Observable wrapper for SwiftUI binding
class VentureEngineWrapper: ObservableObject {
    private var engine = VentureEngine()

    @Published var currentNode: VentureNode?

    init() {
        currentNode = engine.currentNode
    }

    func advance(to id: String) {
        engine.advance(to: id)
        currentNode = engine.currentNode
    }
}

// MARK: - Placeholder Modal Views

struct PlayMusicView: View {
    var body: some View {
        Text("🎵 Now playing music...")
            .font(.title)
            .padding()
    }
}

struct APICallView: View {
    var body: some View {
        Text("🌐 API call initiated...")
            .font(.title)
            .padding()
    }
}

struct MiniGameView: View {
    var body: some View {
        Text("🎮 Mini-game coming soon!")
            .font(.title)
            .padding()
    }
}
