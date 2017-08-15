//
//  AddFriendsTableViewCell.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 13/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import BEMCheckBox
import Firebase

class AddFriendsTableViewCell: UITableViewCell, BEMCheckBoxDelegate {

    @IBOutlet var friendProfileImage: UIImageView!
    
    @IBOutlet var friendUserName: UILabel!

    @IBOutlet var checkBoxToFollow: BEMCheckBox!
    
    let user = Auth.auth().currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func checkBoxToFollowAction(_ sender: Any) {
        let buttonRow = (sender as AnyObject).tag
        //print(buttonRow)
        print(checkBoxToFollow.on)
        if checkBoxToFollow.on == true {
            print("adding")
        let p = allUsers[buttonRow!].AuthFirebaseKey
        let post : [String: AnyObject] = ["Friend" : p as AnyObject]
        let databaseRef = Database.database().reference()
            databaseRef.child((user?.uid)!).child("Friends").childByAutoId().setValue(post)
        } else if checkBoxToFollow.on == false {
            print("deleting")
            let p = allUsers[buttonRow!].AuthFirebaseKey
            let r = snapKeys[buttonRow!]
            let post : [String: AnyObject] = ["Friend" : p as AnyObject]
            let databaseRef = Database.database().reference().child((user?.uid)!).child("Friends")
        //databaseRef.child(r).removeValue()
   databaseRef.queryOrdered(byChild: "Friend").queryEqual(toValue: p).observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
    snapshot.ref.removeValue(completionBlock: {(error, reference) in
        if error != nil{
            print("There is an error")
        }
    })
        })
            
        }
//print("this is being tapped")
 
    }
}
