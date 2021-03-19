//
//  RootVC.swift
//  howLong
//
//  Created by Lahari Ganti on 2/20/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class RootVC: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var dotNodes = [SCNNode]()
    var textNode = SCNNode()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "howLong"
        sceneView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if dotNodes.count >= 2 {
            for dot in dotNodes {
                dot.removeFromParentNode()
            }
            dotNodes = [SCNNode]()
        }

        if let touchLocation = touches.first?.location(in: sceneView) {
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitTestResult = hitTestResults.first {
                addDot(at: hitTestResult)
            }
        }
    }

    func addDot(at location: ARHitTestResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]

        let dotNode = SCNNode(geometry: dotGeometry)

        dotNode.position = SCNVector3(x: location.worldTransform.columns.3.x,
                                      y: location.worldTransform.columns.3.y,
                                      z: location.worldTransform.columns.3.z)

        sceneView.scene.rootNode.addChildNode(dotNode)

        dotNodes.append(dotNode)

        if dotNodes.count >= 2 {
            calculateDistance()
        }
    }

    func calculateDistance() {
        let start = dotNodes[0]
        let end = dotNodes[1]

        let distance = abs(sqrt(pow((start.position.x - end.position.x), 2) +
                                pow((start.position.y - end.position.y), 2) +
                                pow((start.position.z - end.position.z), 2)))

        updateText(text: "\(distance) m", at: end.position)
    }


    func updateText(text: String, at position: SCNVector3 ) {
        textNode.removeFromParentNode()
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        textGeometry.materials = [material]
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(x: position.x, y: position.y + 0.01, z: position.z )
        textNode.scale = SCNVector3(0.003, 0.003, 0.003)

        sceneView.scene.rootNode.addChildNode(textNode)
    }
}


extension RootVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }
}
