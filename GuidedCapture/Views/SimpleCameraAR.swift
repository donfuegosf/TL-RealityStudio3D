import SwiftUI
import SceneKit
import ARKit

struct ARCubeView: UIViewRepresentable {
    var modelURL: URL
    @Binding var clearScene: Bool
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = context.coordinator
        initializeARSession(sceneView: sceneView)
        // Configure the AR session with world tracking and plane detection

        
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        context.coordinator.sceneView = sceneView // Set the sceneView in the coordinator
        
        return sceneView
    }
    private func initializeARSession(sceneView: ARSCNView) {
        // Configure the AR session with world tracking and plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Add a slight delay and reset the session to force reinitialization
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    
    
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
            if clearScene {
                uiView.scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
                DispatchQueue.main.async {
                                // Reset the state to false to allow for re-triggering
                                self.clearScene = false
                            }  // Reset the flag after clearing
            }
        }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(modelURL: modelURL)
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var sceneView: ARSCNView?  // This will be set post creation
        var modelURL: URL
        
        init(modelURL: URL) {
            self.modelURL = modelURL
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor, let sceneView = sceneView else { return }
            let planeNode = createPlaneNode(planeAnchor: planeAnchor)
            node.addChildNode(planeNode)
        }
        
        private func createPlaneNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
            plane.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.eulerAngles.x = -.pi / 2
            return planeNode
        }
        
        @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard let sceneView = self.sceneView,
                  let location = gestureRecognizer.view as? ARSCNView,
                  let query = location.raycastQuery(from: gestureRecognizer.location(in: location), allowing: .existingPlaneGeometry, alignment: .horizontal),
                  let result = location.session.raycast(query).first else {
                return
            }
            loadModel(at: result.worldTransform, in: location)
        }
        
        private func loadModel(at transform: simd_float4x4, in sceneView: ARSCNView) {
            guard let scene = try? SCNScene(url: modelURL, options: nil),
                  let modelNode = scene.rootNode.childNodes.first else {
                print("Failed to load the model from URL: \(modelURL)")
                return
            }
            modelNode.position = SCNVector3(transform.columns.3.x, transform.columns.3.y , transform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(modelNode)
        }
    }
}

struct SimpleCameraAr: View {
    var modelURL: URL
    @State private var clearScene = false  // State to control scene clearing

    var body: some View {
        VStack {
            ARCubeView(modelURL: modelURL, clearScene: $clearScene)
                .edgesIgnoringSafeArea(.all)
            
            Button("Clear Scene") {
                clearScene = true  // Set the state to true when the button is tapped
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}
