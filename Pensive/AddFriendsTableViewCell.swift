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

    @IBOutlet var progressImageView: UIView!
    
    @IBOutlet var checkBoxToFollow: BEMCheckBox!
    
    let user = Auth.auth().currentUser
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
// print("THIS IS ANIMATING THE VIEW")
        friendProfileImage.layer.borderWidth = 1
        friendProfileImage.layer.masksToBounds = false
        friendProfileImage.layer.borderColor = UIColor.orange.cgColor
        friendProfileImage.layer.cornerRadius = friendProfileImage.frame.height/2
        friendProfileImage.clipsToBounds = true
        
        
    }
    
  
    @IBAction func checkBoxToFollowAction(_ sender: Any) {
        let buttonRow = (sender as AnyObject).tag
        //print(buttonRow)
        print(checkBoxToFollow.on)
        if checkBoxToFollow.on == true {
            print("adding")
        let p = allUsers[buttonRow!].AuthFirebaseKey
        let b = allUsers[buttonRow!].Username
        let post : [String: AnyObject] = ["Friend" : p as AnyObject , "FriendUsername" : b as AnyObject]
        let databaseRef = Database.database().reference()
            databaseRef.child((user?.uid)!).child("Friends").childByAutoId().setValue(post)
        } else if checkBoxToFollow.on == false {
            let p = allUsers[buttonRow!].AuthFirebaseKey
            
            for friend in allFriends {
                if friend.AuthFirebaseKey == p {
            let databaseRef = Database.database().reference().child((user?.uid)!).child("Friends")
                databaseRef.child(friend.snapshotKey!).removeValue()
                    print("deleting")
                }
            }
           // let r = snapKeys[buttonRow!]
          //  print(r)
          //  let databaseRef = Database.database().reference().child((user?.uid)!).child("Friends")
        //    databaseRef.child(r).removeValue()
        //    print("deleting")
            
            /*
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
         */
        }
//print("this is being tapped")
 }
    
 
}

