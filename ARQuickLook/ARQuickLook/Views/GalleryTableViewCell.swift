//
//  GalleryTableViewCell.swift
//  ARQuickLook
//
//  Created by Lahari Ganti on 3/28/21.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {
  @IBOutlet weak var modelImage: UIImageView!
  @IBOutlet weak var modelName: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.clipsToBounds = true
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
