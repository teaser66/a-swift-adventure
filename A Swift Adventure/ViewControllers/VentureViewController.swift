

//
//  VentureViewController.swift
//  A Swift Adventure
//
//  Created by Rob Faiella on 4/18/25.
//

import UIKit
import SwiftUI
import WebKit

class VentureViewController: UIViewController, CodeShowable {
    var codeKey: String { return "VentureViewController" }
    var codeFileKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let engineWrapper = VentureEngineWrapper() // Use the wrapper
        guard let startNode = engineWrapper.currentNode else { return }

        let rootView = VentureView(node: startNode, engineWrapper: engineWrapper, onChoiceSelected: navigateToNextScreen)

        let hostingController = UIHostingController(rootView: rootView)

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

    // This method is called when a choice is selected in the SwiftUI view
    private func navigateToNextScreen(choice: VentureChoice) {
        let modalType = ModalType(rawValue: choice.nextNodeID) ?? .none
        let newViewController = GameActionViewController(incomingAction: modalType)
        navigationController?.pushViewController(newViewController, animated: true)
    }
}

struct VentureView: View {
    @ObservedObject var engineWrapper: VentureEngineWrapper
    @State private var currentNode: VentureNode?
    @State private var choices: [VentureChoice] = []
    var onChoiceSelected: (VentureChoice) -> Void

    init(node: VentureNode, engineWrapper: VentureEngineWrapper, onChoiceSelected: @escaping (VentureChoice) -> Void) {
        self._currentNode = State(initialValue: node)
        self._engineWrapper = ObservedObject(initialValue: engineWrapper)
        self.onChoiceSelected = onChoiceSelected
    }

    var body: some View {
        NavigationView {
            VStack {
                if let imageName = currentNode?.imageName, let image = UIImage(named: imageName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .padding()
                }

                if let currentNode = currentNode {
                    Text(currentNode.prettyText)
                        .font(.headline)
                        .padding()

                    ForEach(choices, id: \ .nextNodeID) { choice in
                        Button(action: {
                            handleChoice(choice)
                        }) {
                            Text(choice.title)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(4)
                    }
                }
            }
            .navigationBarTitle("Venture Adventure", displayMode: .inline)
            .onAppear {
                loadCurrentNode()
            }
        }
    }

    private func loadCurrentNode() {
        if let current = engineWrapper.currentNode {
            currentNode = current
            choices = engineWrapper.getRandomChoices(limit: 2)
        }
    }

    private func handleChoice(_ choice: VentureChoice) {
        engineWrapper.advance(to: choice.nextNodeID)
        if let nextNode = engineWrapper.currentNode {
            currentNode = nextNode
            choices = engineWrapper.getRandomChoices(limit: 2)
        }
        onChoiceSelected(choice)
    }
}

struct NodeDetailView: View {
    var node: VentureNode
    var body: some View {
        VStack {
            Text(node.prettyText)
                .font(.headline)
                .padding()
            Button("Go Back") {
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}

struct GameOverView: View {
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

class VentureEngineWrapper: ObservableObject {
    private var engine = VentureEngine()
    @Published var currentNode: VentureNode?

    init() {
        currentNode = engine.currentNode
    }

    func getRandomChoices(limit: Int = 2) -> [VentureChoice] {
        return self.engine.getRandomChoices(limit: limit)
    }

    func advance(to nodeID: String) {
        engine.advance(to: nodeID)
        currentNode = engine.currentNode
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
