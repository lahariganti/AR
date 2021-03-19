//
//  RootVC.swift
//  diceIT
//
//  Created by Lahari Ganti on 2/18/19.
//  Copyright © 2019 Lahari Ganti. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RootVC: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var diceArray: [SCNNode] = [SCNNode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        title = "diceIT"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(rollAgain))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAllDice))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if let hitResults = results.first {
                addDice(at: hitResults)
            }
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
         rollAllDice()
    }

    func addDice(at location: ARHitTestResult) {
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")
        if let diceNode = diceScene?.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(x: location.worldTransform.columns.3.x,
                                           y: location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                                           z: location.worldTransform.columns.3.z)

            diceArray.append(diceNode)
            sceneView.scene.rootNode.addChildNode(diceNode)
            roll(diceNode)
        }
    }

    func roll(_ dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)
        let randomZ = Float(arc4random_uniform(4) + 1) * (Float.pi / 2)

        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomZ * 5), duration: 0.5))
    }

    func rollAllDice() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice)
            }
        }
    }
}

extension RootVC: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        let planeNode = createPlane(with: planeAnchor)
        node.addChildNode(planeNode)
    }

    func createPlane(with planeAnchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        return planeNode
    }
}

extension RootVC {
    @objc func deleteAllDice() {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }

    @objc func rollAgain() {
        rollAllDice()
    }
}
