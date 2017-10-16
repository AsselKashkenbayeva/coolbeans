//
//  CollectionViewCell.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 10/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
 

    @IBOutlet var friendProfileImageFromMap: UIImageView!
   
    @IBOutlet var nameForLabelMap: UILabel!
    
    @IBOutlet var viewForeBorderFromFriendSlider: UIView!

  //  @IBOutlet var ViewforBorderInMap: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // friendProfileImageFromMap.layer.borderWidth = 1
        friendProfileImageFromMap.layer.masksToBounds = false
       // friendProfileImageFromMap.layer.borderColor = UIColor.orange.cgColor
        friendProfileImageFromMap.layer.cornerRadius = friendProfileImageFromMap.frame.height/2
      friendProfileImageFromMap.clipsToBounds = true
        friendProfileImageFromMap.frame = CGRect(x: 5, y: 5, width: 50, height: 50)
        viewForeBorderFromFriendSlider.frame = CGRect(x: 0, y: 0, width: (friendProfileImageFromMap.frame.width) + 8 , height: (friendProfileImageFromMap.frame.height) + 8)
        nameForLabelMap.frame = CGRect(x: friendProfileImageFromMap.frame.minY, y: friendProfileImageFromMap.frame.maxY, width: self.frame.width, height: 30)
        viewForeBorderFromFriendSlider.center = friendProfileImageFromMap.center
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

    override func prepareForReuse() {
    super.prepareForReuse()
    }

   
}
