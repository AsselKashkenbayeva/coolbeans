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
// FIRDatabase.database().persistenceEnabled = true
            navigationItem.title = "User Feed"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
       fetchUser()
    }

       func fetchUser() {
            let ref = FIRDatabase.database().reference()
            ref.observe( .childAdded, with: { (snapshot) in
             //print(snapshot)
               if let dictionary = snapshot.value as? [String: AnyObject] {
                //print(dictionary)
                let user = USER()
                user.Username = dictionary["Username"]?["Username"] as? String
                user.Email = dictionary["Email"]?["Email"] as? String
                user.ProfilePicURL = dictionary["ProfilePicURL"]?["ProfilePicURL"] as? String
             
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
           
                }
                }
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
        
       if let profileImageURL = user.ProfilePicURL {
            let url = URL(string: profileImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
        
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.masksToBounds = false
       cell.imageView?.layer.borderColor = UIColor.orange.cgColor
        cell.imageView?.layer.cornerRadius = 70
        cell.imageView?.clipsToBounds = true
 
        return cell
    }
        
}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
