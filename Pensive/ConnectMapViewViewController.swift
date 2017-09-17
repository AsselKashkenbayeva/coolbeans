//
//  ConnectMapViewViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 30/04/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import IGLDropDownMenu




class ConnectMapViewViewController: UIViewController, GMSMapViewDelegate, IGLDropDownMenuDelegate {
    /*
//This is setting the map view
    @IBOutlet var vwGMap: GMSMapView!
//This is setting the detail pop up when marker is clicked
    @IBOutlet var friendDetailMapView: UIView!
//These are the labels on the detail pop up when marker is clicked
    @IBOutlet var detailName: UILabel!
    @IBOutlet var detailAddress: UILabel!
    @IBOutlet var detailWebsite: UILabel!
//This is the button which user presses to add friends place onto own map which brings up pop up window to allow user to pick folder they want to store the selection in
    @IBOutlet var addToCattchButton: UIButton!
//This is setting up the pop up window when 'add to cattche' is clicked on the detail pop up window
    @IBOutlet var pickFolder: UIView!
//This is the button to add place to the Firebase and to the current users stored places of interest
    @IBOutlet var addButton: UIButton!
//This is the label displayed in the picking folder window which asks which folder the user wants to save the selected place in
    @IBOutlet var whichFolderLabel: UILabel!
//This is the profile picture of the selected friend to be displayed on the top of the map view as a subview
    @IBOutlet var friendProfilePic: UIImageView!
    
//Accessing the USER class where the all the information from Firebase is directed from
    var selectedUser = (USER)()
    
    var markersArray = [CLLocationCoordinate2D]()
    var nameArray = [String]()
    var addressArray = [String]()
    var websiteArray = [String]()
    var placeIDArray = [String]()
    var telephoneArray = [String]()
    
    var folderIconIndex = ""
    var folderItem = ""
    var website = ""
    var placeID = ""
    var telephone = ""
    
    var tappedMarker = CLLocationCoordinate2D()
    
    var currentuser = Auth.auth().currentUser
    
    var dropDownMenuFolder = IGLDropDownMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFriends()
//This is rendering the navigation bar at the top seethrough
navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
navigationController?.navigationBar.shadowImage = UIImage()
        
//This is trying to show the profile picture of the user at the top of the mapview.
        friendProfilePic.layer.borderWidth = 1
        friendProfilePic.layer.masksToBounds = false
        friendProfilePic.layer.borderColor = UIColor.orange.cgColor
        friendProfilePic.layer.cornerRadius = friendProfilePic.frame.height/2
        friendProfilePic.clipsToBounds = true
      
        
        
        
        //vwGMap.addSubview(friendProfilePic)
       // friendProfilePic.image = UIImage(named: "a")
      /*
       let url = NSURL(string: selectedUser.ProfilePicURL!)!
        let internet = NSData(contentsOf: url as URL)!
        friendProfilePic.image = UIImage(data: internet as Data)
         vwGMap.addSubview(friendProfilePic)
        */
        /*
        if let url = NSURL(string: selectedUser.ProfilePicURL!) {
            if let imageData = NSData(contentsOf: url as URL) {
                let str64 = imageData.base64EncodedData(options: .lineLength64Characters)
                let data: NSData = NSData(base64Encoded: str64 , options: .ignoreUnknownCharacters)!
                let dataImage = UIImage(data: data as Data)
                self.friendProfilePic.image = dataImage
                /
            }
        }
        */
//This is a loop extracting the information from a dictionary about the saved places of a user
        for snap in selectedUser.StoredPlacesOfUser {
            let key = snap.key
            let latitude = (selectedUser.StoredPlacesOfUser[key]?["Latitude"] as? NSString)?.doubleValue
            let longitude = (selectedUser.StoredPlacesOfUser[key]?["Longitude"] as? NSString)?.doubleValue
            
            let markers = GMSMarker()
            markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
            let folderIcon = selectedUser.StoredPlacesOfUser[key]?["FolderIcon"] as? String
            self.markersArray.append(markers.position)
            
            markers.icon = UIImage(named:folderIcon!)
            markers.tracksViewChanges = true
            markers.map = self.vwGMap
            
            let placeName = selectedUser.StoredPlacesOfUser[key]?["StoredPlaceName"] as? String
            self.nameArray.append(placeName!)
            
            let placeID = selectedUser.StoredPlacesOfUser[key]?["StoredPlaceID"] as? String
            self.placeIDArray.append(placeID!)
            
            let placeAddress = selectedUser.StoredPlacesOfUser[key]?["StoredPlaceAddress"] as? String
            self.addressArray.append(placeAddress!)
            
            let telephone = selectedUser.StoredPlacesOfUser[key]?["StoredPlaceTelephone"] as? String
            self.telephoneArray.append(telephone!)
            
            let website = selectedUser.StoredPlacesOfUser[key]?["StoredPlaceWebsite"] as? String
            self.websiteArray.append(website!)
            
        }
   
        vwGMap.delegate = self
      
        //This is setting the default view on London
        vwGMap.camera = GMSCameraPosition.camera(withLatitude: 51.5114, longitude: -0.1100 , zoom: 10.0)
      
        vwGMap.settings.scrollGestures = true
        vwGMap.settings.zoomGestures = true
        vwGMap.settings.compassButton = true
        vwGMap.settings.allowScrollGesturesDuringRotateOrZoom = true
        
        setupInIt()

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
                        print("this is the firebase all friends func\(allFriends.count)")
                        // snapKeys.append(key)
                        // friends.updateValue(key as AnyObject, forKey: "firebaseKey")
                    }
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
    


    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tappedMarker = marker.position
        
        friendDetailMapView.center = mapView.projection.point(for: tappedMarker)
        friendDetailMapView.center.y -= 100
        
        self.view.addSubview(friendDetailMapView)
        
        for i in 0...(markersArray.count-1) {
            if  markersArray[i].latitude == tappedMarker.latitude &&  markersArray[i].longitude == tappedMarker.longitude
            {
                detailName.text = self.nameArray[i]
                
                detailAddress.text = self.addressArray[i]
                
                self.website = self.websiteArray[i]
             
                self.telephone = self.telephoneArray[i]
                self.placeID = self.placeIDArray[i]
                
                itemIndex = i
                //if picture of person who it is taken from
                
            } else {
            }
        }
        return false
    }
    
    @IBAction func addToCattcheAction(_ sender: Any) {
        self.view.addSubview(pickFolder)
    // self.vwGMap.addSubview(dropDownMenuFolder)
    //    self.pickFolder.addSubview(dropDownMenuFolder)
       setupInIt()
        //This is trying to set the second window at the bottom of the screen. The constraints are related to the size of the map view window.
        let bob = vwGMap.bounds.width
        let bkb = vwGMap.frame.maxY
     pickFolder.center = CGPoint(x: bob/2, y: bkb-40)
     whichFolderLabel.text = ("which folder would you like to add \(detailName.text!) to ?" )
    }
    
 //This is setting up the drop down menu items. The items are populated by the Firebase folders object of the current user.
func setupInIt() {
    let dropdownItems: NSMutableArray = NSMutableArray()
        
        if STOREDFolders.count > 0 {
            for i in 0...(STOREDFolders.count-1) {
                let item = IGLDropDownItem()
                item.text = (STOREDFolders[i]["FolderName"] as! String!)
                item.iconImage = UIImage(named: STOREDFolders[i]["FolderIcon"] as! String!)
                item.iconImage.accessibilityIdentifier = STOREDFolders[i]["FolderIcon"] as! String!
                dropdownItems.add(addObject:item)
            }
        }
        else {
        }
    
        dropDownMenuFolder.menuText = "Choose Folder"
        dropDownMenuFolder.dropDownItems  = dropdownItems as [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
        dropDownMenuFolder.frame = CGRect(x: pickFolder.frame.origin.x+30, y: pickFolder.frame.origin.y+25, width: 200, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.direction = IGLDropDownMenuDirection.up
        dropDownMenuFolder.type = IGLDropDownMenuType.slidingInBoth
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
    
        //I am not sure this myLabal is useful for anything 
    /*
        let myLabel = UILabel()
       // myLabel.text = "SwiftyOS Blog"
      //  myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 12)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.frame = CGRect(x: pickFolder.frame.origin.x+20, y: pickFolder.frame.origin.y+25, width: 200, height: 45)
   // self.pickFolder.addSubview(myLabel)
 */
    
    pickFolder.addSubview(dropDownMenuFolder)
    
    }
    
    //This is delegate for what is selected in dropdown menu when adding new place
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        let item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        //This allows to identify the text of the selected drop down item
        let folderItem = item.text
        self.folderItem = folderItem!
        //This allows to identify the icon image in the selected drop down item
        let folderIconIndex = item.iconImage.accessibilityIdentifier
        self.folderIconIndex = folderIconIndex!
        
    }

    //This closes both pop up windows
    @IBAction func closeDetailAction(_ sender: Any) {
     friendDetailMapView.removeFromSuperview()
     pickFolder.removeFromSuperview()
    }
    
    //This is when you press 'add' on second window, it will add users place to their own list
    @IBAction func addButtonAction(_ sender: Any) {
        //this is the information being saved in Firebase
        let post : [String: AnyObject] = ["StoredPlaceName" : detailName.text as AnyObject, "StoredPlaceID" : self.placeID as AnyObject, "StoredPlaceAddress" : detailAddress.text as AnyObject, "StoredPlaceWebsite" : self.website as AnyObject, "StoredPlaceTelephone" : self.telephone as AnyObject,  "PlaceUnderFolder" : folderItem as AnyObject,"FolderIcon" : folderIconIndex as AnyObject,  "Longitude" : tappedMarker.longitude as AnyObject, "Latitude" : tappedMarker.latitude as AnyObject /*"VisitedCheckbox" : true as AnyObject*/]
        
    //Making a call to Firebase and saving data under the current user
     let databaseRef = Database.database().reference()
 databaseRef.child((self.currentuser?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
      
    //Closing all the pop up windows after action
           friendDetailMapView.removeFromSuperview()
           pickFolder.removeFromSuperview()
        
          // dropDownMenuFolder.removeFromSuperview()
        
    }
  
    */
}
