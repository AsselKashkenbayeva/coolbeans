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
    override func layoutSubviews() {
        super.layoutSubviews()
        profilePicForSlider2.layer.borderWidth = 1
        profilePicForSlider2.layer.masksToBounds = false
        profilePicForSlider2.layer.borderColor = UIColor.orange.cgColor
        profilePicForSlider2.layer.cornerRadius = 20
        profilePicForSlider2.clipsToBounds = true
        //self.friendProfileImageFromMap.image = nil
        
    }
}
