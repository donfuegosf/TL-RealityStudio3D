import SwiftUI
import SceneKit
import ARKit

struct ARCubeView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = context.coordinator
        
        context.coordinator.sceneView = sceneView
        
        // Configure the AR session with world tracking and plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
                sceneView.addGestureRecognizer(tapGestureRecognizer)
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update the AR scene view during SwiftUI state updates
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var sceneView: ARSCNView?
        
        
        
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
            material.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [material]
            
            return planeNode
        }
        
        @objc func handleTap(_ gestureRecognize: UITapGestureRecognizer) {
                    // Get the location of the tap in the sceneView
                    let location = gestureRecognize.location(in: sceneView)

                    guard let sceneView = self.sceneView,
                          let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal),
                          let result = sceneView.session.raycast(query).first else {
                        return
                    }

                    // Create a simple cube and place it at the raycast result
                    let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
                    cubeNode.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
                    sceneView.scene.rootNode.addChildNode(cubeNode)
                }
        
    }
}

struct SimpleCameraAr: View {
    var body: some View {
        ARCubeView()
            .edgesIgnoringSafeArea(.all)
    }
}
