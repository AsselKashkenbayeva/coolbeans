//
//  CollectionViewCell.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 10/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet var friendProfileImage: UIImageView!
    
  
    @IBOutlet var friendProfileImageFromMap: UIImageView!
   
    @IBOutlet var nameForLabelMap: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
     
    }
    override func prepareForReuse() {
    super.prepareForReuse()
       // friendProfileImage.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    friendProfileImage.layer.borderWidth = 1
    friendProfileImage.layer.masksToBounds = false
    friendProfileImage.layer.borderColor = UIColor.orange.cgColor
    friendProfileImage.layer.cornerRadius = 20
    friendProfileImage.clipsToBounds = true
        self.friendProfileImage.image = nil
    }
    
    @IBOutlet var friendUsernameLabel: UILabel!
   
}
