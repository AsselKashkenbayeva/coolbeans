//
//  FriendSliderViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 10/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase


class FriendSliderViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!, UIImage(named: "5")!, UIImage(named: "6")!]
    
   
      var user = Auth.auth().currentUser
    var allFilters: [FILTER] = []
    let mygroup = DispatchGroup()

    @IBOutlet var collectionViewWindow: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        fetchFolder()
        fetchFriends()
        /*
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
    print("this is the slider view sotred folders count\(STOREDFolders.count)")
        print("THIS IS FROM FRIEND SLIDER HELLO")
        //self.folderNames.removeAll()
        for folder in STOREDFolders {
            print("this is storedfolders\(STOREDFolders.count)")
            //self.mygroup.enter()
            let name = (folder["FolderName"] as? String!)
            let image = (folder["FolderIcon"] as? String)!
            self.folderNames.append(name!)
            self.folderIconNames.append(image)
          //  self.mygroup.leave()
        }
            
            self.collectionViewWindow.reloadData()
            */
        
      //  mygroup.notify(queue: .main) {
       //     print("this stuff is completed")
       //     print(self.folderNames)
       // }
    }
    
    func fetchFolder() {
    
        let ref = Database.database().reference().child((user?.uid)!).child("UserFolders")
        ref.observe( .value, with: { (snapshot) in
            var rmIndices = [Int]()
//            if let index = self.allFilters.index(where: { $0.type == "folder" }) {
//                self.allFilters.remove(at: index)
//                //continue do: arrPickerData.append(...)
//            }
//          
            var count = self.allFilters.count
            if self.allFilters.count > 0 {
            for index in 0...(self.allFilters.count-1) {
                
                if self.allFilters[index].type == "folder" {
                    rmIndices.append(index)
                }
                }
                self.allFilters = self.allFilters.enumerated().flatMap {rmIndices.contains($0.0) ? nil : $0.1}
            }
             var allFolders = [FILTER]()
        
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let key = snap.key
                    //print(key)
                    let folder = FILTER()
                    folder.name = (dictionary[key]?["FolderName"] as? String)!
                    folder.icon = (dictionary[key]?["FolderIcon"] as? String)!
                    folder.key = key
                    folder.type = "folder"
                    // print(dictionary)
                    //folder.name = dictionary["Username"] as? String
                     print(folder.name!)
                    
                    allFolders.append(folder)
                    
                                   }
                }
                self.allFilters = allFolders + self.allFilters
                // if self.folders.contains(folder) {
                // print("YES")
                //}
                DispatchQueue.main.async {
                    self.collectionViewWindow.reloadData()
                    print("This should print at the end of completed task ")
                    
                }
            }
        }
            )
        
    }
  
    func fetchFriends() {
        let ref = Database.database().reference()
        ref.child((self.user?.uid)!).child("Friends").observe( .value, with: { (snapshot) in
            var rmIndices = [Int]()
            if self.allFilters.count > 0 {
                for index in 0...(self.allFilters.count-1) {
                    
                    if self.allFilters[index].type == "friend" {
                        rmIndices.append(index)
                    }
                }
                self.allFilters = self.allFilters.enumerated().flatMap {rmIndices.contains($0.0) ? nil : $0.1}
            }
            var friends = [FILTER]()
            allFriends.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let friend = USER()
                        friend.snapshotKey = snap.key
                        let key = snap.key
                        friend.AuthFirebaseKey = (dictionary[key]?["Friend"] as? String)
                        friend.Username = (dictionary[key]?["FriendUsername"] as? String)
                        
                        let friendFilter = FILTER()
                        friendFilter.path = (dictionary[key]?["Friend"] as? String)
                        friendFilter.name = (dictionary[key]?["FriendUsername"] as? String)
                        friendFilter.type = "friend"
                    friends.append(friendFilter)
                        
                        //["Friend"]
                        
                        allFriends.append(friend)
                        // let friend = (dictionary[key] as? [String: AnyObject]!)!
                        print("this is the firebase all friends func\(allFriends.count)")
                        // snapKeys.append(key)
                        // friends.updateValue(key as AnyObject, forKey: "firebaseKey")
                        
                    }
                    
                    
                }
                self.allFilters = self.allFilters + friends
                DispatchQueue.main.async {
                    self.collectionViewWindow.reloadData()
                    print("This should print at the end of completed task ")
                    
                }

                if allFriends.count > 0 {
                    print("this is AFTER all friends has been populated\(allFriends.count)")
                    for friend in allFriends {
                        let ref = Database.database().reference().child(friend.AuthFirebaseKey!).child("StoredPlaces")
                        ref.observe( .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                // print(snapshot)
                                for snap in snapshots {
                                    if let dictionary = snapshot.value as? [String: AnyObject] {
                                        let key = snap.key
                                        
                                        friend.StoredPlacesOfUser = (dictionary[key] as? [String: AnyObject]!)!
                                        print(friend.StoredPlacesOfUser)
                                    }
                                }
                            }
                        })
                    }
                }
                
            }
        }
        )
        
    }
    
    
    
    
    
    
    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return allFilters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let folder = allFilters[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.friendProfileImage.image = UIImage(named: folder.icon!)
        
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(folder.icon!)
        if fileManager.fileExists(atPath: imagePath){
            cell.friendProfileImage.image = UIImage(contentsOfFile: imagePath)
            print("I have uploaded image from internal database")
        }else{
            print("Panic! No Image!")
            cell.friendProfileImage.image = UIImage(named: "funProfilePic")
        }
 
        cell.friendProfileImage.image = UIImage(named: "funProfileIcon")
        cell.friendUsernameLabel.text = folder.name
        return cell
    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFilter = allFilters[indexPath.row]
        if selectedFilter.type == "folder" {
            let firstViewController:
                FirstViewController = self.storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            firstViewController.filterSelected = selectedFilter.name!
            firstViewController.filterPlaces()
            
       //firstViewController.vwGMap.addSubview(firstViewController.detailsPopUp)
        } else {
            
        }
        
       
    }
}

