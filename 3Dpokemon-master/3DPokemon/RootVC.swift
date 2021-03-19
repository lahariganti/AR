//
//  RootVC.swift
//  3DPokemon
//
//  Created by Lahari Ganti on 2/21/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class RootVC: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.delegate = self

        let configuration = ARImageTrackingConfiguration()
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "pokemonCards", bundle: Bundle.main) {
            configuration.maximumNumberOfTrackedImages = 2
            configuration.trackingImages = imageToTrack
        }

        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

}

extension RootVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 0, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi/2
            node.addChildNode(planeNode)

            if imageAnchor.referenceImage.name == "meowth" {
                if let pokeScene = SCNScene(named: "art.scnassets/meowth.scn") {
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        pokeNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }

            if imageAnchor.referenceImage.name == "snorlax" {
                if let pokeScene = SCNScene(named: "art.scnassets/snorlax.scn") {
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        pokeNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
        }
        return node
    }
}
