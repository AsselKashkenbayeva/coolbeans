//
//  AddFriendsViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 13/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase
 var allUsers = [USER]()

//var snapKeys = [String]()
var friends = [String: AnyObject]()
class AddFriendsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {


    @IBOutlet var addFriendsTableView: UITableView!
  //  var allUsers = [USER]()
//    var friends = [String]()
     let currentuser = Auth.auth().currentUser
    var boolArray = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()

        addFriendsTableView.delegate = self
        addFriendsTableView.dataSource = self
        fetchUser()
        fetchFriends()
    }

    func fetchUser() {
        allUsers.removeAll()
        let ref = Database.database().reference()
        ref.observe( .childAdded, with: { (snapshot) in
          //  print("THe firebase is being called after changing loading")
            if let dictionary = snapshot.value as? [String: AnyObject] {
            //    print(dictionary)
                 let User = USER()
            User.AuthFirebaseKey = snapshot.key
             //   print(User.AuthFirebaseKey)
                 User.Username = dictionary["Username"]?["Username"] as? String
                 User.ProfilePicURL = dictionary["ProfilePicURL"]?["ProfilePicURL"] as? String
                /*
                if (dictionary["Friends"] != nil) {
                User.Friends = (dictionary["Friends"] as? [String:AnyObject])!
                    print(User.Friends)
                }
 */
               // print(type(of: User.ProfilePicURL))
                 //print(User.ProfilePicURL?.isEmpty)
             //  print(User.ProfilePicURL)
        
                if User.AuthFirebaseKey != self.currentuser?.uid && User.AuthFirebaseKey != "AddRecommendation" {
                    allUsers.append(User)
                    if User.ProfilePicURL == nil {
                      //  print("Profile pic is equal to nil")
                    } else {
                        self.saveImage(imageName: User.AuthFirebaseKey!, passedURL: User.ProfilePicURL!)
                        // print(User.AuthFirebaseKey)
                    }
                    
                }
                
           
 
                DispatchQueue.main.async {
                    self.addFriendsTableView.reloadData()
                }
            }
        }
        )}

   
    func saveImage(imageName: String, passedURL: String){
   
        if passedURL.isEmpty {
          //  print("There is no photo")
            return
        } else {
        let url = NSURL(string: passedURL) as! URL
         //   print("this is the passed url")
         //   print(url)
   
    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print("THERE IS AN ERROR")
                return
            }
           
           // DispatchQueue.main. {
             //   print("THIS IS GOING TO BE A PIC")
               // cell.friendProfileImage.image = UIImage(data: data!)
                let fileManager = FileManager.default
                //get the image path
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                  let data = UIImagePNGRepresentation(UIImage(data: data!)!)
                 fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
         //  }
        }).resume()
    }

        
}

  
    
    func fetchFriends() {
        let ref = Database.database().reference()
    ref.child((self.currentuser?.uid)!).child("Friends").observe( .value, with: { (snapshot) in
          //  print("THIS THE FIREBASE VALUE IS BEING CALLED")
           // snapKeys.removeAll()
              allFriends.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let friend = USER()
                        friend.snapshotKey = snap.key
                        let key = snap.key
                      friend.AuthFirebaseKey = (dictionary[key]?["Friend"] as? String)
                     friend.Username = (dictionary[key]?["FriendUsername"] as? String)
                        
                        //["Friend"]
                        
                        allFriends.append(friend)
                       // let friend = (dictionary[key] as? [String: AnyObject]!)!
                        
                      // snapKeys.append(key)
          // friends.updateValue(key as AnyObject, forKey: "firebaseKey")
                    }
                }
            }
        }
    )
        //havent finished implimenting the child removal
      
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
                // print(allFriends)
            var bool = Bool()
       
            for User in allUsers {
                for friend in allFriends {
           if (User.AuthFirebaseKey?.contains(friend.AuthFirebaseKey!))! {
                  bool = true
            break
            
                } else {
                 bool = false
        
                }
                    
                }
                 self.boolArray.append(bool)
            }
              //   print(self.boolArray)
    }
    }
           /*
                if (dictionary["Friends"] != nil) {
                    allUsers.Friends = (dictionary["Friends"] as? [String:AnyObject])!
                    print(allUsers.Friends)
                }
*/
         

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let User = allUsers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendsCell", for: indexPath) as! AddFriendsTableViewCell
        cell.friendProfileImage.image = UIImage(named: "funProfileIcon")
      // cell.checkBoxToFollow.on = checkboxTick
     cell.friendUserName.text = User.Username
        
   //     for User in allUsers {
       // print("This is printing the allfriends count")
        //print(allFriends.count)
            for friend in allFriends {
                if (User.AuthFirebaseKey?.contains(friend.AuthFirebaseKey!))! {
                    cell.checkBoxToFollow.on = true
                       // print("THIS matches the friend list")
                    break
                } else {
                    cell.checkBoxToFollow.on = false
                   //  print("This does not match friend list ")
                }
            }
      //  }
     
    
        
        
        
        
        
        
      //  print("THIS IS COMING FROM CELL")
       // print(cell.friendUserName.text)
     //   print(indexPath.row)
        /*
        for friend in allFriends {
            if friend.AuthFirebaseKey == User.AuthFirebaseKey {
                cell.checkBoxToFollow.on = true
                print("THIS matches the friend list")
            } else {
                cell.checkBoxToFollow.on = false
                print("This does not match friend list ")
            }
        }
 */
        /*
        if self.friends.contains(User.AuthFirebaseKey!) {
            cell.checkBoxToFollow.on = true
        }
        else {
            cell.checkBoxToFollow.on = false
        }
        */
      // print(cell.checkBoxToFollow.on)

        /*
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
         */
      //  cell.friendProfileImage.image = imageWithImage(image: UIImage(named: "MapIcon")!, scaledToSize: CGSize(width: 40, height: 40))
    
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(User.AuthFirebaseKey!)
        if fileManager.fileExists(atPath: imagePath){
           cell.friendProfileImage.image = UIImage(contentsOfFile: imagePath)
           // print("I have uploaded image from internal database")
            
        }else{
          //  print("Panic! No Image!")
            var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 150, y: 300, width: 100, height: 100)
            indicator.center = view.center
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
           cell.progressImageView.addSubview(indicator)
          
        }

        /*
        cell.friendProfileImage.sizeToFit()
        cell.friendProfileImage.layer.borderWidth = 1
        cell.friendProfileImage.layer.masksToBounds = false
        cell.friendProfileImage.layer.borderColor = UIColor.orange.cgColor
        cell.friendProfileImage.layer.cornerRadius = 70
        cell.friendProfileImage.clipsToBounds = true
        cell.friendProfileImage.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
*/
       
        cell.checkBoxToFollow.tag = indexPath.row
        
       cell.checkBoxToFollow.addTarget(self, action: "didTap:", for: UIControlEvents.touchUpInside)
        //print(indexPath.row)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(indexPath.row)
    
        /*
         // Segue to the second view controller
         
         let myVC = storyboard?.instantiateViewController(withIdentifier: "ConnectMapViewController") as! ConnectMapViewViewController
         myVC.selectedUser = users[indexPath.row]
         // self.performSegue(withIdentifier: "connectMapView", sender: self)
         navigationController?.pushViewController(myVC, animated: true)
         */
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

