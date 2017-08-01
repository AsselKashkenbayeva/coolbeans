//
//  FirstViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 24/10/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//




import UIKit

import GoogleMaps
import GooglePlaces



import Firebase
import FirebaseDatabase
import FirebaseAuth

import BTNavigationDropdownMenu
import IGLDropDownMenu

import BubbleTransition


var STOREDPlaces = [[String:AnyObject]]()
var STOREDFolders = [[String:AnyObject]]()
var itemIndex = Int()

class markerUserData{
    var nameUserData: String
    var addressUserData: String
    var websiteUserData: String
    var telephoneUserData: String
    var firebaseKey : String
    var rating: Int
    var checkbox: Bool
    var tags: String
    var placepicture: String
    init(Name: String, Address: String, Website: String, Telephone: String, FirebaseKey: String, Rating: Int, Checkbox: Bool, Tags: String, PlacePicture: String) {
        self.nameUserData = Name
        self.addressUserData = Address
        self.websiteUserData = Website
        self.telephoneUserData = Telephone
        self.firebaseKey = FirebaseKey
        self.rating = Rating
        self.checkbox = Checkbox
        self.tags = Tags
        self.placepicture = PlacePicture
    }
}
class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate, IGLDropDownMenuDelegate, UIViewControllerTransitioningDelegate, DataEnteredDelegate {
    
      let transition = BubbleTransition()
    
    //Container for viewing Gmaps
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    var Markers = [GMSMarker]()
  
    @IBOutlet var moreDetailButton: UIButton!
 
    @IBOutlet var detailsPopUp: UIView!
    
    @IBOutlet var detailsName: UILabel!
    
    @IBOutlet var websiteLabel: UITextView!
    
    @IBOutlet var ratingControl: RatingControl!
    
    
    @IBOutlet var mapCustomInfoWindow: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var AddNewPlaceButton: UIButton!
    
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
    var newPlaceTelephone = ""
   
    var folderItem = ""
    var folderIconIndex = ""
    
    var telephone = ""
    var openNowStatus = ""
    var types = ""
    var priceLevel = ""
    var website = ""
    
    
    var latitudeText = ""
    var longitudeText = ""
    var newPlaceNameText = ""
    


    var storedPlaceLatitude = ""
    var storedPlaceLongitude = ""
    
    var user = Auth.auth().currentUser
    var databaseRef = Database.database().reference()
    
    var effect:UIVisualEffect!

    
    var dropDownMenuFolder = IGLDropDownMenu()
    
    var tappedMarker = CLLocationCoordinate2D()
    var folderNames = [String]()
    
    var markersArray = [CLLocationCoordinate2D]()
    var placeIDsArray = [String]()
    var placeNamesArray = [String]()
    var placeWebsiteArray = [String]()
    
    var filterSelected = ""
    
    var markerID = ""
 
    var firebaseKey = ""
    var ratingControlRating = Int()
    var checkboxBool: Bool = false
    var tagsMarker = ""
    var markerPlacePictureURL = ""
    var tappedMarkerAddress = ""
    var tappedMarkerTelephone = ""
    
    var longPressCoordinate = CLLocationCoordinate2D()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dropDownMenuFolder.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector (TapFuncTwo(_sender:)))
        tap.numberOfTapsRequired = 1
        dropDownMenuFolder.addGestureRecognizer(tap)
        
        
        
        
        
        
       self.filterSelected = "All"
        
        //dont forget to set trackchanges for updates to the info window
        
    //    fetchFolders()
        
        
        // self.view = dropDownMenuFolder
        
        // removes the navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // this is for the sort by drop down menu
        effect = visualEffectView?.effect
        visualEffectView?.isHidden = true
        visualEffectView?.effect = nil
        //addNewItem.layer.cornerRadius = 5
        
        
        /*
         var blur = UIBlurEffect(style: UIBlurEffectStyle.light )
         var blurview = UIVisualEffectView(effect: blur)
         blurview.alpha = 0.8
         blurview.frame = mapView.bounds
         self.view.addSubview(blurview)
         */
        
        //Initially uploading googleMaps
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.300000, longitude: 70.783300, zoom: 10.0)
        vwGMap = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        vwGMap.camera = camera
        vwGMap.settings.scrollGestures = true
        vwGMap.settings.zoomGestures = true
        vwGMap.settings.myLocationButton = true
        vwGMap.settings.compassButton = true
        vwGMap.settings.allowScrollGesturesDuringRotateOrZoom = true
 
        //setting the delegate
        vwGMap.delegate = self
        
        //allowing and finding the current location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 500
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.view = vwGMap
        
//This is getting access to the database and accessing the stored places child information and storing it into a local STOREDPlaces dictionary
        let ref = Database.database().reference().child((user?.uid)!).child("StoredPlaces")
        
        ref.observe( .value, with: { (snapshot) in
            STOREDPlaces.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        self.firebaseKey = key
                        var PLACE = (dictionary[key] as? [String: AnyObject]!)!
                        PLACE?.updateValue(self.firebaseKey as AnyObject, forKey: "firebaseKey")
                        STOREDPlaces.append(PLACE!)
                    }
                }
                
            }
        }
        )

//This does the same as previous but accesses the stored folders file and places into the STOREDFolders dict
        let refFolders = Database.database().reference().child((user?.uid)!).child("UserFolders")
        
        refFolders.observe( .value, with: { (snapshot) in
            STOREDFolders.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        let FOLDER = (dictionary[key] as? [String: AnyObject]!)!
                        
                        STOREDFolders.append(FOLDER!)
                       
                    }
                }
            }
        }
        )
        /*
        //retreive Stored Place Photo from firebase
        let userID: String = (Auth.auth().currentUser?.uid)!
        
        let storageRef = Storage.storage().reference().child(userID).child(firebaseKey).child("StoredPlacePicture")
        ref.child(userID).child(firebaseKey).child("StoredPlacePicture").observe(.value, with: { (snapshot) in
            storageRef.getData(maxSize: 10*1024*1024, completion: {(data, error) -> Void in
                if (error != nil) {
                    print("got no pic")
                } else {
                    
                    let storedPlacePicture = UIImage(data: data!)
                   // self.image = profilePhoto
                    print("I HAVE YOUR PHOTO")
                }
            }
            )}
        )
        */
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.folderNames.removeAll()
            for r in STOREDFolders  {
                let folder = r["FolderName"] as? String
                
                self.folderNames.append(folder!)
          //print("This is in the storedfolders for loop")
            }
          
            self.setupInIt()
            self.sortByDropDown()
            self.filterPlaces()
        }
  
    }
    func TapFunc(sender: UITapGestureRecognizer) {
        //print("THIS IS BEING TAPPED")
        self.folderNames.removeAll()
        for r in STOREDFolders  {
            let folder = r["FolderName"] as? String
            self.folderNames.append(folder!)
        }
         //self.dropDownMenuFolder.reloadView()
        /*
        let items = self.folderNames
        folderNames.append("All")
           let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Sort By", items: items as [AnyObject])
        menuView.updateItems(self.folderNames as! [AnyObject])
 */
        self.sortByDropDown()
        self.setupInIt()
  // detailsPopUp.markers = markers
    }
 
    
  /*
    override func viewDidAppear(_ animated: Bool) {
      
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
        
            self.folderNames.removeAll()
            for r in STOREDFolders  {
                let folder = r["FolderName"] as? String
                
                self.folderNames.append(folder!)
       
            }
      
            self.setupInIt()
           self.sortByDropDown()
           // self.filterPlaces()
           
        }
        
    }
 */
    
 
        
 
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let items = self.folderNames
        folderNames.append("All")
     let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Sort By", items: items as [AnyObject])
        menuView.isHidden = true
        menuView.hide()
    }
 
    func filterPlaces() {
 //       self.detailsPopUp.removeFromSuperview()
        self.markersArray.removeAll()
        //  self.placeIDsArray.removeAll()
       self.placeNamesArray.removeAll()
       // self.placeWebsiteArray.removeAll()
        self.vwGMap.clear()
        print("Filter places function is being called")
        if self.filterSelected == "All"
            
        {
            for p in STOREDPlaces {
                let latitude = (p["Latitude"] as? NSString)?.doubleValue
                let longitude = (p["Longitude"] as? NSString)?.doubleValue
              //  let placeIDs = (p["StoredPlaceID"] as? String)
               
               let markers = GMSMarker()
                markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
             //  self.placeIDsArray.append(placeIDs!)
               self.markersArray.append(markers.position)
                let folderIcon = p["FolderIcon"] as? String
                markers.icon = UIImage(named:folderIcon!)
            //   markers.tracksViewChanges = true
                let name = p["StoredPlaceName"] as? String
                let website = p["StoredPlaceWebsite"] as? String
                let address = p["StoredPlaceAddress"] as? String
                 let firebaseKey = p["firebaseKey"] as? String
               let rating = p["Rating"] as? Int
                let checkbox = p["Checkbox"] as? Bool
                let tags = p["Tags"] as? String
                let placePicture = p["StoredPlacePicture"] as? String
            //  markers.title = name
        markers.accessibilityValue = name
            // markers.snippet = address
               self.placeNamesArray.append(name!)
           //     self.placeWebsiteArray.append(website!)

                markers.map = self.vwGMap
               
                self.vwGMap.setNeedsDisplay()
                
                let storedPlaceUserData = markerUserData(Name: name!, Address: address!, Website: website!, Telephone: folderIcon!, FirebaseKey: firebaseKey!, Rating: rating!, Checkbox: checkbox!, Tags: tags!, PlacePicture: placePicture!)
               markers.userData = storedPlaceUserData

            }
        }
        else if self.filterSelected != "All"  {
            for p in STOREDPlaces {
                if p["PlaceUnderFolder"] as? String == self.filterSelected {
                    print(self.filterSelected)
                    let latitude = (p["Latitude"] as? NSString)?.doubleValue
                    let longitude = (p["Longitude"] as? NSString)?.doubleValue
                    let markers = GMSMarker()
                    markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
                    self.markersArray.append(markers.position)
                 
                    let folderIcon = p["FolderIcon"] as? String
                    let name = p["StoredPlaceName"] as? String
                    let website = p["StoredPlaceName"] as? String
                    let address = p["StoredPlaceAddress"] as? String
                     let firebaseKey = p["firebaseKey"] as? String
             let rating = p["Rating"] as? Int
                    let checkbox = p["Checkbox"] as? Bool
                      let tags = p["Tags"] as? String
                     let placePicture = p["StoredPlacePicture"] as? String
                    markers.accessibilityValue = name
                    let storedPlaceUserData = markerUserData(Name: name!, Address: address!, Website: website!, Telephone: folderIcon!, FirebaseKey: firebaseKey!, Rating: rating!, Checkbox: checkbox!, Tags: tags!, PlacePicture: placePicture!)
                   markers.userData = storedPlaceUserData
                    print((markers.userData as! markerUserData).firebaseKey)
                    self.placeNamesArray.append(name!)
              //  self.placeWebsiteArray.append(website!)
                    markers.icon = UIImage(named:folderIcon!)
                  // markers.tracksViewChanges = true
                    markers.map = self.vwGMap
                 
                    self.vwGMap.setNeedsDisplay()
                    
                
                }
            }
        }
      
    }

    func sortByDropDown() {
    //self.detailsPopUp.removeFromSuperview()
      
        let items = self.folderNames
        folderNames.append("All")
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Sort By", items: items as [AnyObject])
        menuView.updateItems(self.folderNames as [AnyObject])
      self.navigationItem.titleView = menuView
        self.navigationItem.titleView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TapFunc(sender:)))
        tapGesture.numberOfTapsRequired = 1
        self.navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        menuView.cellTextLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        menuView.menuTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        menuView.cellSelectionColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
      //  menuView.hide()
      //  menuView.toggle()
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
           
           // print("Did select item at index: \(indexPath)")
          // print(self?.folderNames[indexPath])
   //   self?.filterSelected  = (self?.folderNames[indexPath])!
    
        //  print(self?.filterSelected)
           // print(indexPath)
            if indexPath != nil {
          self?.filterSelected = (self?.folderNames[indexPath])!
               // print((self?.filterSelected)!)
            self?.filterPlaces()
                /*
                self?.folderNames.removeAll()
                for r in STOREDFolders  {
                    let folder = r["FolderName"] as? String
                    self?.folderNames.append(folder!)
                }
           // self?.dropDownMenuFolder.reloadView()
           //    menuView.updateItems(self?.folderNames as! [AnyObject])
                
                */
            }
            return
        }
    }
    
    
    /*
    //This is fetching the folders from Firebase
    func fetchFolders() {
        let ref = FIRDatabase.database().reference().child((self.user?.uid)!).child("UserFolders")
        ref.observe( .childAdded, with: { (snapshot) in
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    
                    let folder = (dictionary["FolderName"] as? String?)!
                    self.Folders.append(folder!)
                   
                    
                    // print(self.Folders)
                    /*
                     folders.append(folder!)
                     DispatchQueue.main.async {
                     self.Folders = folders
                     print(self.Folders)      }
                     */
                }
                
            }
        })
        
    }
    */
    
    //This is setting up the dropdown menu in the add new place pop up
    func TapFuncTwo(_sender: UITapGestureRecognizer) {
        print("THIS IS BEING TAPPED")
        
        
    }
    func setupInIt() {
        
        let dropdownItems: NSMutableArray = NSMutableArray()

        if STOREDFolders.count > 0 {
            for i in 0...(STOREDFolders.count-1) {
                let item = IGLDropDownItem()
                item.text = (STOREDFolders[i]["FolderName"] as! String!)
                item.iconImage = UIImage(named: STOREDFolders[i]["FolderIcon"] as! String!)
                item.iconImage.accessibilityIdentifier = STOREDFolders[i]["FolderIcon"] as! String!
              //THERE NEEDS TO BE SOMETHING HERE THAT MAKES SURE IF AN ICON WAS NOT PICKED AND NIL FOUND IT IS HANDLED.
                dropdownItems.add(addObject:item)
               // print(item.iconImage.accessibilityIdentifier)
            }
        }
        else {
            
        }
        
        dropDownMenuFolder.menuText = "Choose Folder"
        dropDownMenuFolder.dropDownItems  = dropdownItems as [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
     //   let x = mapCustomInfoWindow.frame.width
     //   let y = mapCustomInfoWindow.frame.height
        
        dropDownMenuFolder.frame = CGRect(x: 50, y: 145 , width: 200, height: 45)
     // dropDownMenuFolder.center = mapCustomInfoWindow.center
        //85 x, 120 y
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.stack
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
/*
        let myLabel = UILabel()
//        myLabel.text = "SwiftyOS Blog"
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.frame = CGRect(x: 40, y: 60, width: 200, height: 45)
        
        self.mapCustomInfoWindow.addSubview(myLabel)
        */
     
       
        dropDownMenuFolder.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector (TapFuncTwo(_sender:)))
        tap.numberOfTapsRequired = 1
        dropDownMenuFolder.addGestureRecognizer(tap)
  
 
        
    //mapCustomInfoWindow.addSubview(dropDownMenuFolder)
    }
  
    
    //This is delegate for what is selected in dropdown menu when adding new place
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        let item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        let folderItem = item.text
        self.folderItem = folderItem!
        let folderIconIndex = item.iconImage.accessibilityIdentifier
        self.folderIconIndex = folderIconIndex!
        
    }

    /*
    //This is setting up the details infoWindow pop up
    func animatedIn() {
        
        self.view.addSubview(detailsPopUp)
        detailsPopUp.center = self.view.center
        
        detailsPopUp.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        detailsPopUp.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView?.effect = self.effect
            self.visualEffectView?.isHidden = false
            self.detailsPopUp.alpha = 1
            self.detailsPopUp.transform = CGAffineTransform.identity
        }
    }
    */
    
    //MARK: Current location permission requests
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            vwGMap.isMyLocationEnabled = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        vwGMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
     /*
        let circleCenter = newLocation?.coordinate ;
        let circ = GMSCircle(position: circleCenter!, radius: 200)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
         let CLocation = CLLocation(latitude: 51.5074, longitude: 0.1278)
        let location = newLocation?.distance(from: CLocation)
        
        circ.map = self.vwGMap
        self.view = self.vwGMap 
 */
        
 }
    
    //MARK: GMSMapview Delegate
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.vwGMap.isMyLocationEnabled = true }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.vwGMap.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil }
    }
    
    //MARK: GoogleMaps Autocomplete
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.place = place
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.vwGMap.camera = camera
       let marker = GMSMarker()
       self.marker = marker
        marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        marker.accessibilityValue = place.name
   
      //  marker.snippet = place.formattedAddress
        marker.map = self.vwGMap
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        self.dismiss(animated: true, completion: nil)
   // marker.tracksViewChanges = false
     //   let newPlaceName = place.name
        self.newPlaceName = place.name
        var newPlaceNameText:String = "\(newPlaceName)"
        self.newPlaceNameText = "\(newPlaceName)"
      //  let newPlaceAddress = place.formattedAddress
        self.newPlaceAddress = place.formattedAddress!
      //  let newPlacePlaceID = place.placeID
        self.newPlacePlaceID = place.placeID
        
        let newPlaceLatitude = place.coordinate.latitude
        var latitudeText:String = "\(newPlaceLatitude)"
        self.latitudeText = "\(newPlaceLatitude)"
        
        
        let newPlaceLongitude = place.coordinate.longitude
        var longitudeText:String = "\(newPlaceLongitude)"
        self.longitudeText = "\(newPlaceLongitude)"
        
        var telephone = place.phoneNumber
        if telephone == nil {
            self.telephone = ""
        } else {
        self.telephone = telephone!
        }
        var website =  place.website
        //this doesnt really save the website
        if website == nil {
            self.website = ""
        } else {
            var newWebsite = website!
        self.website = "\(newWebsite)"
        }
        tappedMarker = marker.position
            }
    
    //Initiated if autocomplete failed
    func viewController(_ viewcontroller: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)") }
    
    //Initiated if autocomplete cancelled
    func wasCancelled(_ viewController:GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)   }
    
    //This allows the search button to be clicked
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchWithAddress = GMSAutocompleteViewController()
        searchWithAddress.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "UK"
        self.locationManager.startUpdatingLocation()
        
        self.present(searchWithAddress, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
       tappedMarker = marker.position
        
        self.ratingControlRating = ratingControl.rating
    
                    if marker.userData  == nil {
             detailsName.text = marker.accessibilityValue
          
            
           //detailsPopUp.removeFromSuperview()
        } else {
            //tappedMarker = marker.position
            detailsName.text = (marker.userData as! markerUserData).nameUserData
                        
            self.firebaseKey = (marker.userData as! markerUserData).firebaseKey
            ratingControl.firebaseKey = firebaseKey
        ratingControl.rating = (marker.userData as! markerUserData).rating
        checkboxBool = (marker.userData as! markerUserData).checkbox
        tagsMarker = (marker.userData as! markerUserData).tags
        websiteLabel.text = (marker.userData as! markerUserData).websiteUserData
        markerPlacePictureURL = (marker.userData as! markerUserData).placepicture
        tappedMarkerTelephone = (marker.userData as! markerUserData).telephoneUserData
        tappedMarkerAddress = (marker.userData as! markerUserData).addressUserData
          
        }
       detailsPopUp.layer.borderWidth = 2
        detailsPopUp.layer.borderColor = UIColor.darkGray.cgColor
          self.view.addSubview(detailsPopUp)
   // detailsName.text = marker.userData
    //  detailsPopUp.center = mapView.projection.point(for: marker.position)
    //    detailsPopUp.center.y -= 100
      //  print(marker.accessibilityValue)
    
        //detailsName.text = marker.title
     // self.view.addSubview(detailsPopUp)
        /*
         for i in 0...(markersArray.count-1) {
            if markersArray[i].latitude == tappedMarker.latitude &&  markersArray[i].longitude == tappedMarker.longitude
             
            {
                 self.view.addSubview(detailsPopUp)
           // detailsName.text = (marker.userData[i]["StoredPlaceName"] as? String)
                //self.placeNamesArray[i]
              
           // detailWebsite.text = self.placeWebsiteArray[i]
                print("MATCHING")
            itemIndex = i
                //if picture of person who it is taken from
               
            } else {
                detailsName.text = marker.title
               print("NOTHING MATCHING")
          
            }
            
        }
        
     //   detailImageView.image = UIImage(named: "b")
        */
        return false
    }
    
    //This produces the coordinate of where it tapped on the map, doesn't work on tapped markers
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
     print(String(coordinate.latitude))
     print(String(coordinate.longitude))
     }
     */
    
    //This prints out the details just by clicking on a place need to enable this
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
        
    }
    
    //This is so that the addPlace window tacks onto place with marker
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
     //   let location = marker.position
        
       detailsPopUp.center = mapView.projection.point(for: tappedMarker)
       detailsPopUp.center.y -= 110
        mapCustomInfoWindow.center = mapView.projection.point(for: longPressCoordinate)
        mapCustomInfoWindow.center.y -= 150
        dropDownMenuFolder.center = mapCustomInfoWindow.center
        //dropDownMenuFolder.center = mapView.projection.point(for: location)
    
        
       // dropDownMenuFolder.center.y -= 150
    }
    
    
    //When doing long press, it shows pop up window above icon
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
       let location = coordinate
        longPressCoordinate = location
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
       dropDownMenuFolder.center = mapCustomInfoWindow.center
    //mapCustomInfoWindow.addSubview(dropDownMenuFolder)
        mapCustomInfoWindow.layer.borderWidth = 2
        mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
        self.view.addSubview(mapCustomInfoWindow)
        self.view.addSubview(dropDownMenuFolder)
    }
    
    @IBOutlet weak var CancelAddNewPlace: UIButton!
    
    //When adding new place, saves place to Firebase, changes icon to selected
    @IBAction func AddNewPlaceAction(_ sender: Any) {
        
        let PlaceName: String = self.newPlaceNameText
        let PlaceAddress: String = self.newPlaceAddress
        let PlaceTelephone: String = self.telephone
        let PlaceWebsite = self.website
        let PlaceID = self.newPlacePlaceID
        let PlaceUnderFolder = self.folderItem
        let LongitudeCoordinate = self.longitudeText
        let LatitudeCoordinate = self.latitudeText
        let FolderIcon = self.folderIconIndex
        //this is not correct because it shows the whole array in one part
        let post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "StoredPlaceAddress" : PlaceAddress as AnyObject, "StoredPlaceWebsite" : PlaceWebsite as AnyObject, "StoredPlaceTelephone" : PlaceTelephone as AnyObject,  "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : LongitudeCoordinate as AnyObject, "Latitude" : LatitudeCoordinate as AnyObject, "Rating" : 0 as AnyObject, "Tags" : "" as AnyObject, "Checkbox" : false as AnyObject, "StoredPlacePicture": "" as AnyObject ]
        
        let databaseRef = Database.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
     
        marker.icon = UIImage(named: FolderIcon )
        mapCustomInfoWindow.removeFromSuperview()
        //this drop down menu does not appear after opening the window once
        dropDownMenuFolder.removeFromSuperview()
    }

    //This is the cancel button in when a user is asked to add a new place
    @IBAction func CancelAddNewPlace(_ sender: Any) {
        //This is a great way to update stuff to update things in the detail view. 
        /*   let ref = FIRDatabase.database().reference().child((user?.uid)!).child("StoredPlaces")
         let query = ref.queryOrdered(byChild: "StoredPlaceName").queryEqual(toValue: "Costa Coffee")
         
         query.observe(.childAdded, with: { (snapshot) in
         snapshot.ref.updateChildValues(["StoredPlaceID": self.aaa] )
         })
         */
                mapCustomInfoWindow.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
    }
    
    @IBAction func detailCloseAction(_ sender: Any) {
     detailsPopUp.removeFromSuperview()
    }
    
    @IBAction func detailMoreDetailAction(_ sender: Any) {
        if ratingControlRating != 0 {
            print("not")
        }
    }
    func userDidEnterInformation(info: String) {
        print(info)
        tagsMarker = info
    }
    func userDidChangePhoto(info2: UIImage) {
    }
    func userDidChangeRating(info3: Int) {
        selectedPlace.updateValue(info3 as AnyObject, forKey: "Rating")
    // ratingControlRating = selectedPlace.updateValue(info3 as AnyObject, forKey: "Rating") as! Int
       
    }
    func userDidChangeCheckbox(info4: Bool) {
        selectedPlace.updateValue(info4 as AnyObject, forKey: "Checkbox")
        checkboxBool = info4
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

filterPlaces()
        let controller = segue.destination as! DetailViewController
       controller.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        controller.modalPresentationStyle = .custom
        controller.delegate = self
      //  let drinks = STOREDPlaces.map({$0["Tags"]})
    
       
        var markerDict = ["StoredPlaceName": detailsName.text, "Rating": ratingControl.rating, "firebaseKey" : firebaseKey, "Checkbox" : checkboxBool, "Tags" : tagsMarker, "StoredPlacePicture" : markerPlacePictureURL, "StoredPlaceAddress" : tappedMarkerAddress, "StoredPlaceWebsite": websiteLabel.text, "StoredPlaceTelephone": tappedMarkerTelephone] as [String : Any]
        
       selectedPlace = markerDict as [String : AnyObject]
    //   ratingControl.selectedPlaceDetail = markerDict as [String : AnyObject]
    }
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = moreDetailButton.center
        transition.bubbleColor = moreDetailButton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = moreDetailButton.center
        transition.bubbleColor = moreDetailButton.backgroundColor!
        return transition
    }
    

}

