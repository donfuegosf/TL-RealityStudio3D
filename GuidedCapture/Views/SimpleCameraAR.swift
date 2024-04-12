import SwiftUI
import SceneKit
import ARKit

struct ARCubeView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = context.coordinator
        
        // Configure the AR session with world tracking and plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update the AR scene view during SwiftUI state updates
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            let planeNode = createPlaneNode(planeAnchor: planeAnchor)
            node.addChildNode(planeNode)
        }
        
        private func createPlaneNode(planeAnchor: ARPlaneAnchor) -> SCNNode {
            let plane = SCNPlane(width: CGFloat(planeAnchor.planeExtent.width), height: CGFloat(planeAnchor.planeExtent.height))
            let planeNode = SCNNode(geometry: plane)
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            planeNode.eulerAngles.x = -.pi / 2
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.gray // Example color
            plane.materials = [material]
            
            return planeNode
        }
    }
}

struct SimpleCameraAr: View {
    var body: some View {
        ARCubeView()
            .edgesIgnoringSafeArea(.all)
    }
}
