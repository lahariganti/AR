//
//  RootViewController.swift
//  ARQuickLook
//
//  Created by Lahari Ganti on 3/28/21.
//

import UIKit
import QuickLook

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
  @IBOutlet weak var tableView: UITableView!
  
  let modelNames = ["Teapot", "Gramophone", "Pig"]
  var modelImages = [UIImage]()
  var modelIndex = 0;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    for modelName in modelNames {
      if let modelImage = UIImage(named: "\(modelName).jpg") {
        modelImages.append(modelImage)
      }
    }
    
    let nib = UINib(nibName: "GalleryTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "GalleryTableViewCell")
    self.tableView.estimatedRowHeight = 80
    self.tableView.rowHeight = UITableView.automaticDimension
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return modelNames.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryTableViewCell")! as! GalleryTableViewCell
    
    cell.selectionStyle = .none
    cell.modelImage.image = modelImages[indexPath.row]
    cell.modelName.text = modelNames[indexPath.row]
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    modelIndex = indexPath.row
    let previewController = QLPreviewController()
    previewController.dataSource = self
    previewController.delegate = self
    present(previewController, animated: false)
  }
  
  // MARK: - QLPreviewControllerDataSource
  
  func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
    return 1
  }
  
  func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
    let url = Bundle.main.url(forResource: modelNames[modelIndex], withExtension: "usdz")!
    return url as QLPreviewItem
  }
}

