import UIKit
import SwiftUI
import WebKit

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
    @State private var isShowingCode = false
    var codeURLs: [String: String] = [:]

    var body: some View {
        VStack {
            // Button to toggle code view inside the modal
            Button(action: toggleCodeView) {
                Text(isShowingCode ? "Continue" : "Code")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 50)

            // Display code view (WebView) or modal content based on isShowingCode
           if isShowingCode {
               let key = modalType.rawValue
               if let urlString = codeURLs[key], let url = URL(string: urlString){
                   WebView(url: url) // Display the WebView
                       .frame(maxWidth: .infinity, maxHeight: .infinity)
               } else {
                   Text("Invalid code URL")
                       .padding()
                       .foregroundColor(.red)
               }
           } else {
               // Content based on modalType
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

            // Close button
            Button(action: {
                dismissAction()
            }) {
                Text("Close")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 30) // Adjust as needed
        }
        .padding()
    }

    // Function to toggle the code view
    private func toggleCodeView() {
        isShowingCode.toggle()

        if isShowingCode {
            // Here you can implement the logic to display the code content
            print("Show code content or load WebView")
        } else {
            // Hide code and return to the modal content
            print("Hide code content")
        }
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



struct MiniGameView: View {
    var body: some View {
        Text("🎮 Mini-game coming soon!")
            .font(.title)
            .padding()
    }
}

struct WebView: UIViewRepresentable {
    var url: URL?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = url {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

