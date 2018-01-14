//
//  InstagramFeedCollectionViewCell.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 14/01/2018.
//  Copyright © 2018 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class InstagramFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet var userPostedPhoto: UIImageView!
    @IBOutlet var username: UILabel!
    
    @IBOutlet var removeButton: UIButton!
    @IBOutlet var addButton: UIButton!
    
    @IBAction func addButtonAction(_ sender: Any) {
    }
    
    @IBAction func removeButtonAction(_ sender: Any) {
    }
}
