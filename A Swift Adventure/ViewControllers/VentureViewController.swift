

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
        // Create the new destination screen
        let newViewController = GameActionViewController() 
        
        // Navigate to the new screen while keeping the back button functionality intact
        navigationController?.pushViewController(newViewController, animated: true)
    }
}

// SwiftUI View that represents the adventure UI
struct VentureView: View {
    @ObservedObject var engineWrapper: VentureEngineWrapper
    @State private var currentNode: VentureNode?
    @State private var choices: [VentureChoice] = []
    var onChoiceSelected: (VentureChoice) -> Void // Closure for choice selection
    
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
                
                // Display current node's details
                if let currentNode = currentNode {
                    Text(currentNode.prettyText)
                        .font(.headline)
                        .padding()
                    
                    // Show available choices
                    ForEach(choices, id: \.nextNodeID) { choice in
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
            
            // Get random choices for the current node
            let randomChoices = engineWrapper.getRandomChoices(limit: 2)
            
            // Update choices array
            choices = randomChoices
        }
    }

    private func handleChoice(_ choice: VentureChoice) {
        // Mark this choice as seen in the engine
        engineWrapper.advance(to: choice.nextNodeID)

        // Update the currentNode and choices for the new state
        if let nextNode = engineWrapper.currentNode {
            currentNode = nextNode
            
            // Get random choices for the next node
            let randomChoices = engineWrapper.getRandomChoices(limit: 2)
            
            // Update choices array
            choices = randomChoices
        }

        // Trigger the navigation when a choice is selected
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
                // Go back to the previous node
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

struct ModalExperienceView: View {
    let modalType: ModalType
    var dismissAction: () -> Void
    @State private var isShowingCode = false
    @State private var codeURLs: [String: String] = [:]

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                // Top-right Code/Continue button
                HStack {
                    Spacer()
                    Button(action: toggleCodeView) {
                        Text(isShowingCode ? "Continue" : "Code")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }
                .padding([.top, .trailing], 16)

                // Main content area
                Group {
                    if isShowingCode {
                        let key = modalType.rawValue
                        if let urlString = codeURLs[key], let url = URL(string: urlString) {
                            WebView(url: url)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            Text("Invalid code URL")
                                .padding()
                                .foregroundColor(.red)
                        }
                    } else {
                        switch modalType {
                        case .playMusic:
                            PlayMusicView()
                        case .getAPI:
                            APICallView()
                        case .none:
                            EmptyView()
                        case .takePicture:
                            TakePictureView()
                        case .getCameraRoll:
                            CameraRollView()
                        case .saveToPhotos:
                            SavePhotoView()
                        case .editImage:
                            EditImageView()
                        case .recordVideo:
                            RecordVideoView()
                        case .recordAudio:
                            RecordAudioView()
                        case .postAPI:
                            PostAPIView()
                        case .cacheImage:
                            CacheImageView()
                        case .parseJSON:
                            ParseJSONView()
                        case .combineURLSession:
                            CombineView()
                        case .coreData:
                            CoreDataView()
                        case .userDefaults:
                            UserDefaultsView()
                        case .fileManager:
                            FileManagerView()
                        case .keychain:
                            KeychainView()
                        case .formFun:
                            FormView()
                        case .themes:
                            ThemesView()
                        case .animations:
                            AnimationsView()
                        case .getLocation:
                            LocationView()
                        case .mapkit:
                            MapView()
                        case .localNotifications:
                            NotificationsView()
                        case .haptic:
                            HapticView()
                        case .arKit:
                            ARView()
                        }
                    }
                }

                // Close button at bottom
                Button(action: dismissAction) {
                    Text("Close")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
        }
        .onAppear(perform: loadURLsFromJSON)
    }

    private func toggleCodeView() {
        isShowingCode.toggle()
    }

    private func loadURLsFromJSON() {
        if let url = Bundle.main.url(forResource: "CodeFiles", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let json = try decoder.decode([String: String].self, from: data)
                codeURLs = json
            } catch {
                print("Error loading JSON: \(error.localizedDescription)")
            }
        }
    }
}

// Observable wrapper for SwiftUI binding
class VentureEngineWrapper: ObservableObject {
    private var engine = VentureEngine()  // Your existing VentureEngine instance
    
    @Published var currentNode: VentureNode?

    init() {
        currentNode = engine.currentNode
    }

    // Expose getRandomChoices method correctly
    func getRandomChoices(limit: Int = 2) -> [VentureChoice] {
        // If choices are nil or empty, return an empty array
        return self.engine.getRandomChoices(limit: limit)
    }

    func advance(to id: String) {
        engine.advance(to: id)
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
