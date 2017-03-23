//
//  ConnectTableViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 20/03/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

    class ConnectTableViewController: UITableViewController {
        
        let cellId = "cellId"
        
       var users = [USER]()
        var profilePicArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
 
            navigationItem.title = "User Feed"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
       fetchUser()
    }

       func fetchUser() {
            let ref = FIRDatabase.database().reference()
            ref.observe( .childAdded, with: { (snapshot) in
             print(snapshot)
               if let dictionary = snapshot.value as? [String: AnyObject] {
                //print(dictionary)
                let user = USER()
                user.Username = dictionary["Username"]?["Username"] as? String
                user.Email = dictionary["Email"]?["Email"] as? String
              
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
           
                }
                }
        }
        )
        
        let storageRef = FIRStorage.storage().reference()
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary =  snapshot.value as? [String: AnyObject] {
                 let user = USER()
                user.ProfilePic = dictionary["ProfilePic"] as! UIImage?
            
           
            storageRef.data(withMaxSize: 10*1024*1024, completion: {(data, error) -> Void in
                if (error != nil) {
                    print("got no pic")
                } else {
                    
                    let profilePhoto = UIImage(data: data!)
                    //self.profilePhoto.image = profilePhoto
                    print("THIS BIT IS WORKING")
                }
                }
                )}
        }
        )}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return users.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
     let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.Username
        cell .detailTextLabel?.text = user.Email
       // cell.imageView?.image = UIImage(named: profilePicArray)
        return cell
    }
        
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
