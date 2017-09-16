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
    
    @IBOutlet var friendUsernameLabel: UILabel!
    
    override func layoutSubviews() {
        super .layoutSubviews()
        friendProfileImageFromMap.layer.borderWidth = 1
        friendProfileImageFromMap.layer.masksToBounds = false
        friendProfileImageFromMap.layer.borderColor = UIColor.orange.cgColor
        friendProfileImageFromMap.layer.cornerRadius = 20
        friendProfileImageFromMap.clipsToBounds = true
        //self.friendProfileImageFromMap.image = nil
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //friendProfileImageFromMap.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        /*
        friendProfileImageFromMap.layer.borderWidth = 1
        friendProfileImageFromMap.layer.masksToBounds = false
        friendProfileImageFromMap.layer.borderColor = UIColor.orange.cgColor
        friendProfileImageFromMap.layer.cornerRadius = 20
        friendProfileImageFromMap.clipsToBounds = true
        self.friendProfileImageFromMap.image = nil
 */
    }
    /*
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
    */
   
}
