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

                // Use random, unseen choices
                let choices = engine.getRandomChoices(from: node.choices ?? [])
                ForEach(choices, id: \.title) { choice in
                    Button(action: {
                        if choice.modalType != .none {
                            activeModalTypeRaw = choice.modalType.rawValue
                        }
                        engine.advance(to: choice.nextNodeID)
                    }) {
                        Text(choice.prettyText)
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
    func getRandomChoices(from choices: [VentureChoice]) -> [VentureChoice] {
        // Explicitly access the method from VentureEngine
        return self.engine.getRandomChoices()
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

