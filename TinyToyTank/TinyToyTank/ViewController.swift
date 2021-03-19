//
//  ViewController.swift
//  TinyToyTank
//
//  Created by Lahari Ganti on 3/11/21.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
  @IBOutlet var arView: ARView!
  var tankAnchor: TinyToyTank._TinyToyTank?
  var isActionPlaying: Bool = false

  
  @IBAction func tankLeftPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.tankLeft.post()
  }
  
  @IBAction func tankForwardPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.tankForward.post()
  }
  
  @IBAction func tankRightPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.tankRight.post()
  }
  
  @IBAction func turredLeftPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.turretLeft.post()
  }
  
  @IBAction func canonFiredPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.cannonFire.post()
  }
  
  @IBAction func turretRightPressed(_ sender: Any) {
    if self.isActionPlaying { return }
    else { self.isActionPlaying = true }

    self.tankAnchor!.notifications.turretRight.post()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tankAnchor = try! TinyToyTank.load_TinyToyTank()
    tankAnchor!.cannon?.setParent(tankAnchor!.tank, preservingWorldTransform: true)
    tankAnchor?.actions.actionComplete.onAction = { _ in
      self.isActionPlaying = false
    }
    
    arView.scene.anchors.append(tankAnchor!)
  }
}
