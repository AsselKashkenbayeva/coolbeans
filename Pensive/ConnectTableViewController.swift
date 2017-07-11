//
//  ConnectTableViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 20/03/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

//var combinedCourseArray: [[String: AnyObject]] = [[:]]
    class ConnectTableViewController: UITableViewController {
        
        let cellId = "cellId"
        var profilePic = UIImage()
        var userStoredPlaces = [String: AnyObject]()
        var longitudeArray = [Double]()
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
            
               if let dictionary = snapshot.value as? [String: AnyObject] {
             
                let user = USER()
                user.Username = dictionary["Username"]?["Username"] as? String
                user.Email = dictionary["Email"]?["Email"] as? String
                user.ProfilePicURL = dictionary["ProfilePicURL"]?["ProfilePicURL"] as? String
               
                user.StoredPlacesOfUser = (dictionary["StoredPlaces"] as? [String:AnyObject])!
                user.StoredFoldersOfUser = (dictionary["UserFolders"] as? [String:AnyObject])!
                
                self.users.append(user)
           
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                let when = DispatchTime.now() + 2
                DispatchQueue.main.asyncAfter(deadline: when) {
              
                  
                    }
                
        }
            }
        )}
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return users.count
    }
        func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
            
            UIGraphicsBeginImageContext( newSize )
            image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!.withRenderingMode(.alwaysTemplate)
        }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
 let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
       // let cell: UserCell = UserCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.Username
        cell .detailTextLabel?.text = user.Email
        cell.imageView?.image = imageWithImage(image: UIImage(named: "a")!, scaledToSize: CGSize(width: 40, height: 40))
       if let profileImageURL = user.ProfilePicURL {
            let url = URL(string: profileImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    print("THIS IS GOING TO BE A PIC")
                 cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
      
        cell.imageView?.sizeToFit()
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.borderColor = UIColor.orange.cgColor
        cell.imageView?.layer.cornerRadius = 70
        cell.imageView?.clipsToBounds = true
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
       
        return cell
     
    }
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            // Segue to the second view controller
    
    let myVC = storyboard?.instantiateViewController(withIdentifier: "ConnectMapViewController") as! ConnectMapViewViewController
    myVC.selectedUser = users[indexPath.row]
     // self.performSegue(withIdentifier: "connectMapView", sender: self)
   navigationController?.pushViewController(myVC, animated: true)
        }
}

class UserCell: UITableViewCell {
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "a")
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier:
            reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        profileImageView.widthAnchor.constraint(equalToConstant: 40)
        profileImageView.heightAnchor.constraint(equalToConstant: 40)
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
