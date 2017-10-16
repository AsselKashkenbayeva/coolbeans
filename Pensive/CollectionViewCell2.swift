//
//  CollectionViewCell2.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 17/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class CollectionViewCell2: UICollectionViewCell {
    
    @IBOutlet var profilePicForSlider2: UIImageView!
    
    @IBOutlet var nameLabelForSlider2: UILabel!
    
   // @IBOutlet var viewForCollectionView: UIView!
    
    @IBOutlet var viewForBorderCollectionView2: UIView!
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //profilePicForSlider2.layer.borderWidth = 1
        profilePicForSlider2.layer.masksToBounds = false
        //profilePicForSlider2.layer.borderColor = UIColor.orange.cgColor
        profilePicForSlider2.layer.cornerRadius = profilePicForSlider2.frame.height/2
        profilePicForSlider2.clipsToBounds = true
     viewForBorderCollectionView2.layer.cornerRadius = profilePicForSlider2.layer.cornerRadius
        profilePicForSlider2.frame = CGRect(x: 5, y: 5, width: 60, height: 60)
        viewForBorderCollectionView2.frame = CGRect(x: 5, y: 5, width: (profilePicForSlider2.frame.width) + 8 , height: (profilePicForSlider2.frame.height) + 8)
        
        //self.friendProfileImageFromMap.image = nil
 
    }
}
