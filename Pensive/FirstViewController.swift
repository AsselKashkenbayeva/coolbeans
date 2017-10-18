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

var allFriends = [USER]()
var STOREDPlaces = [[String:AnyObject]]()
var STOREDFolders = [[String:AnyObject]]()
var itemIndex = Int()

//This is the class of a tapped marker
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
    var folderName: String
    init(Name: String, Address: String, Website: String, Telephone: String, FirebaseKey: String, Rating: Int, Checkbox: Bool, Tags: String, PlacePicture: String, FolderName: String) {
        self.nameUserData = Name
        self.addressUserData = Address
        self.websiteUserData = Website
        self.telephoneUserData = Telephone
        self.firebaseKey = FirebaseKey
        self.rating = Rating
        self.checkbox = Checkbox
        self.tags = Tags
        self.placepicture = PlacePicture
        self.folderName = FolderName
    }
}


class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate, IGLDropDownMenuDelegate, UIViewControllerTransitioningDelegate, DataEnteredDelegate,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {

    //This is for the friend slider view
      var allFilters: [FILTER] = []
    //slider with the filters and the friends
    @IBOutlet var friendSlider: UICollectionView!
    @IBOutlet var friendSlider2: UICollectionView!
    //Array of only friends for slider2
     var friendsForSlider2 = [FILTER]()
    //this is for setting the border for the row selected in the slider
    var selectedRowIndex = Int()
    //selected friend selected by user to share recommendation with
    var userToSendRecommendationTo = FILTER()
    @IBOutlet var messageToFriendTextField: UITextField!
// when user clicks to share, view shows up with message textfield and confirm button
    @IBOutlet var popSliderViewWindow: UIView!

    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    
    var Markers = [GMSMarker]()
    
    //pop up window when clicking on location icon on place.
    @IBOutlet var detailsPopUp: UIView!
    @IBOutlet var pictureOfPlace: UIImageView!
    @IBOutlet var detailsName: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var telephoneButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var ratingControl: RatingControl!
    @IBOutlet var moreDetailButton: UIButton!
    let transition = BubbleTransition()
    @IBOutlet var closeDetailsButton: UIButton!
    
    //if tapped marker on friend map, the share button turns into an add button
    @IBOutlet var addToNewFolderButtonInPopUp: UIButton!
    
    //pop up to add a place with the drop down menu
    @IBOutlet var mapCustomInfoWindow: UIView!
    @IBOutlet var nameWhenAddingPlace: UILabel!
    @IBOutlet weak var AddNewPlaceButton: UIButton!
   var dropDownMenuFolder = IGLDropDownMenu()
    @IBOutlet weak var CancelAddNewPlace: UIButton!
   
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    //these variables are used for the autocomplete
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
    var newPlaceTelephone = ""

    var telephone = ""
    var openNowStatus = ""
    var types = ""
    var priceLevel = ""
    var website = ""

    var latitudeText = ""
    var longitudeText = ""
    var newPlaceNameText = ""
    
    var folderItem = ""
    var folderIconIndex = ""
    
    //used for firebase
    var user = Auth.auth().currentUser
    
    //var effect:UIVisualEffect!
   // var folderNames = [String]()
      // var placeWebsiteArray = [String]()
    // var placeIDsArray = [String]()
    //  var storedPlaceLatitude = ""
    //  var storedPlaceLongitude = ""
    // @IBOutlet weak var mapView: GMSMapView!
    //@IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var markersArray = [CLLocationCoordinate2D]()
    var placeNamesArray = [String]()

    
    var filterSelected = ""
    
    var markerID = ""
    
    
   var tappedMarker = CLLocationCoordinate2D()
    var firebaseKey = ""
    var ratingControlRating = Int()
    var checkboxBool: Bool = false
    var tagsMarker = ""
    var markerPlacePictureURL = ""
    
    var tappedMarkerAddress = ""
    var tappedMarkerTelephone = ""
    var tappedMarkerWebsite = ""
    
   // var longPressCoordinate = CLLocationCoordinate2D()
   
   
    
    var afterfirebase = Int()
    var updaterating = Int()
    //this is for trying to render a radius around the users current location.
   // var userCurrentLocation = CLLocationCoordinate2D()
   // var jim = CLLocation()
    
    var MARKers = [GMSMarker]()
    
    let placesClient = GMSPlacesClient.shared()
    
  //  let mygroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       view.addSubview(friendSlider)
        //This makes sure that the collection view in the container is flush with the searchbar at the top
           self.automaticallyAdjustsScrollViewInsets = false
        //friendSlider.isHidden = true
       // sliderFromSharingButton.isHidden = false
       self.filterSelected = "All"
   // friendSlider.isHidden = true
        // removes the navigation bar
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
       
        let attributes = [NSFontAttributeName : UIFont(name: "Oriya Sangam MN", size: 20)!, NSForegroundColorAttributeName : UIColor.orange]
        navigationController?.navigationBar.titleTextAttributes = attributes
        
        
        // this is for the sort by drop down menu
       // effect = visualEffectView?.effect
      // visualEffectView?.isHidden = true
       // visualEffectView?.effect = nil
  
    //let frame = CGRect(x: 0, y: friendSlider.frame.maxY, width: self.view.frame.width, height: self.view.frame.height*0.8)
        let frameForFriendSlider = CGRect(x: 0, y: 64, width: self.view.frame.width, height: (self.view.frame.height*1/4)-64)
        friendSlider.frame = frameForFriendSlider
        let frame = CGRect(x: 0, y: friendSlider.frame.maxY, width: self.view.frame.width, height: (self.view.frame.height*3/4)-50)
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: 22.300000, longitude: 70.783300, zoom: 10.0)
        vwGMap = GMSMapView.map(withFrame: frame  , camera: camera)
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
        
        self.view.addSubview(vwGMap)
        /*
//This is getting access to the database and accessing the stored places child information and storing it into a local STOREDPlaces dictionary
        let ref = Database.database().reference().child((user?.uid)!).child("StoredPlaces")
       // print("THIS IS STORED PLACES IN GOOGLE MAPS VIEW CONTROLLER")
        ref.observe( .value, with: { (snapshot) in
          //  print(self.MARKers.count)
          self.MARKers.removeAll()
          //  print(self.MARKers.count)
            STOREDPlaces.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        self.firebaseKey = key
                        var PLACE = (dictionary[key] as? [String: AnyObject]!)!
                        
                        let latitude = (dictionary[key]?["Latitude"] as? NSString)?.doubleValue
                        let longitude = (dictionary[key]?["Longitude"] as? NSString)?.doubleValue

    let markers = GMSMarker()
   markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
  self.markersArray.append(markers.position)
    
    let folderIcon = (dictionary[key] as? [String: AnyObject]!)!["FolderIcon"]
   markers.icon = UIImage(named:folderIcon! as! String)
                      
    let name = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceName"]
    let website = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceWebsite"]
    let address = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceAddress"]
    let rating = (dictionary[key] as? [String: AnyObject]!)!["Rating"]
    let checkbox = (dictionary[key] as? [String: AnyObject]!)!["Checkbox"]
    let tags = (dictionary[key] as? [String: AnyObject]!)!["Tags"]
    let placePicture = (dictionary[key] as? [String: AnyObject]!)!["StoredPlacePicture"]
    let telephone = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceTelephone"]
    let foldername = (dictionary[key] as? [String: AnyObject]!)!["PlaceUnderFolder"]
                       
    
  markers.accessibilityValue = name as! String
                       
  self.placeNamesArray.append(name! as! String)
                  
                        
        let storedPlaceUserData = markerUserData(Name: name! as! String, Address: address! as! String, Website: website! as! String, Telephone: telephone! as! String, FirebaseKey: key, Rating: rating! as! Int, Checkbox: checkbox! as! Bool, Tags: tags! as! String, PlacePicture: placePicture! as! String, FolderName: foldername as! String)
                        
    markers.userData = storedPlaceUserData
                        
    PLACE?.updateValue(self.firebaseKey as AnyObject, forKey: "firebaseKey")
                        
                        STOREDPlaces.append(PLACE!)
                        
                        self.MARKers.append(markers)
                        //print(self.MARKers.count)
                        
                    }
                }
               self.filterPlaces()
                
            }
        }
        )
       */
        /*
//This does the same as previous but accesses the stored folders file and places into the STOREDFolders dict
        let refFolders = Database.database().reference().child((user?.uid)!).child("UserFolders")
        print("THIS IS STORED FOLDER IN GOOGLE MAPS VIEW CONTROLLER")
       
        refFolders.observe( .value, with: { (snapshot) in
            
            STOREDFolders.removeAll()
            self.folderNames.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                
                        let key = snap.key
                        var FOLDER = (dictionary[key] as? [String: AnyObject]!)!
                          let folder = (dictionary[key] as? [String: AnyObject]!)!["FolderName"]
                        self.folderNames.append(folder! as! String)
                        FOLDER?.updateValue(key as AnyObject, forKey: "firebaseKey")
                        STOREDFolders.append(FOLDER!)
                    }
                    
                }
            }
            self.setupInIt()
        }
        )
 */
        fetchPlaces()
        fetchFolder()
        fetchFriends()
        fetchFriendMessages()
    }
    
    func fetchFriendMessages() {
        //This retreives the messages sent from the users friends.
        let ref = Database.database().reference().child((user?.uid)!).child("FriendMessages")
        
        ref.observe( .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    
                    
                }
            }
        }
        )
    }
    func fetchPlaces() {
        //This is getting access to the database and accessing the stored places child information and storing it into a local STOREDPlaces dictionary. This is called everytime there is an update in the database.
        let ref = Database.database().reference().child((user?.uid)!).child("StoredPlaces")
        
        ref.observe( .value, with: { (snapshot) in
            //  print(self.MARKers.count)
            self.MARKers.removeAll()
            //  print(self.MARKers.count)
            STOREDPlaces.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        self.firebaseKey = key
                        var PLACE = (dictionary[key] as? [String: AnyObject]!)!
                        
                        let latitude = (dictionary[key]?["Latitude"] as? NSString)?.doubleValue
                        let longitude = (dictionary[key]?["Longitude"] as? NSString)?.doubleValue
                        
                        let markers = GMSMarker()
                        markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
                        self.markersArray.append(markers.position)
                        
                        let folderIcon = (dictionary[key] as? [String: AnyObject]!)!["FolderIcon"]
                        markers.icon = UIImage(named:folderIcon! as! String)
                        
                        let name = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceName"]
                        let website = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceWebsite"]
                        let address = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceAddress"]
                        let rating = (dictionary[key] as? [String: AnyObject]!)!["Rating"]
                        let checkbox = (dictionary[key] as? [String: AnyObject]!)!["Checkbox"]
                        let tags = (dictionary[key] as? [String: AnyObject]!)!["Tags"]
                        let placePicture = (dictionary[key] as? [String: AnyObject]!)!["StoredPlacePicture"]
                        let telephone = (dictionary[key] as? [String: AnyObject]!)!["StoredPlaceTelephone"]
                        let foldername = (dictionary[key] as? [String: AnyObject]!)!["PlaceUnderFolder"]
                        
                        
                        markers.accessibilityValue = name as! String
                        
                        self.placeNamesArray.append(name! as! String)
                        
                        
                        let storedPlaceUserData = markerUserData(Name: name! as! String, Address: address! as! String, Website: website! as! String, Telephone: telephone! as! String, FirebaseKey: key, Rating: rating! as! Int, Checkbox: checkbox! as! Bool, Tags: tags! as! String, PlacePicture: placePicture! as! String, FolderName: foldername as! String)
                        
                        markers.userData = storedPlaceUserData
                        
                        PLACE?.updateValue(self.firebaseKey as AnyObject, forKey: "firebaseKey")
                        STOREDPlaces.append(PLACE!)
                        self.MARKers.append(markers)
                        //print(self.MARKers.count)
                    }
                }
                self.filterPlaces()
            }
        }
        )
    }
    
    

    func filterPlaces() {
        self.vwGMap.clear()
       // print("Filter places function is being called")
      //  print(self.filterSelected)
        if self.filterSelected == "All"
        {
            for m in MARKers {
                var marKER = GMSMarker()
                marKER = m
                marKER.map = self.vwGMap
              //  print("this is entering all stored places")
            }
                self.vwGMap.setNeedsDisplay()
        }
        else if self.filterSelected != "All"  {
            for m in MARKers {
                //   print(m)
           if (m.userData as! markerUserData).folderName as? String == self.filterSelected {
            
                var marKER = GMSMarker()
                marKER = m
                marKER.map = self.vwGMap
            //  print("this is entering all stored places")
            }
            }
              self.vwGMap.setNeedsDisplay()
        }
      
    }

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
            //If there are no folders, there is a baseline folder set here
                let item = IGLDropDownItem()
                item.text = "My new list"
                item.iconImage = UIImage(named: "4")
                item.iconImage.accessibilityIdentifier = "4"

                dropdownItems.add(addObject:item)
            
            let folderName = item.text
            let folderIcon = item.iconImage.accessibilityIdentifier
            
            
            let post : [String: AnyObject] = ["FolderName" : folderName as AnyObject, "FolderIcon" : folderIcon as AnyObject ]

            let databaseRef = Database.database().reference()
            databaseRef.child((self.user?.uid)!).child("UserFolders").childByAutoId().setValue(post)
        }
        
        dropDownMenuFolder.menuText = "Choose Folder"
        dropDownMenuFolder.dropDownItems  = dropdownItems as [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
        dropDownMenuFolder.frame = CGRect(x: 50, y: 0 , width: 200, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.stack
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
  
      dropDownMenuFolder.frame.origin.x = mapCustomInfoWindow.center.x-dropDownMenuFolder.frame.width/2
 
    }
  
    
    //This is delegate for what is selected in dropdown menu when adding new place
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        let item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        let folderItem = item.text
        self.folderItem = folderItem!
        let folderIconIndex = item.iconImage.accessibilityIdentifier
        self.folderIconIndex = folderIconIndex!
        AddNewPlaceButton.isUserInteractionEnabled = true
        AddNewPlaceButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    //MARK: Current location permission requests
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse)
        {
            vwGMap.isMyLocationEnabled = true
            /*
            let circleCenter = CLLocationManager. ;
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
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        //jim = newLocation!
       // userCurrentLocation = (newLocation?.coordinate)!
        
        vwGMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 7)
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
       // locationsInsideRadius()

 }
    /*
    func locationsInsideRadius() {
        let circleCenter = jim.coordinate
        let circ = GMSCircle(position: circleCenter, radius: 200)
        
        for p in STOREDPlaces {
            let latitude = (p["Latitude"] as? NSString)?.doubleValue
            let longitude = (p["Longitude"] as? NSString)?.doubleValue
            let place = CLLocation(latitude: latitude!, longitude: longitude!)
    let distanceInMeters = jim.distance(from: place )
        if distanceInMeters <= 200 {
            print(p[("StoredPlaceName" as? String)!])
        } else {
            print("NOT NOT NOT")
        }
        }
      
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
        let CLocation = CLLocation(latitude: 51.5074, longitude: 0.1278)
        let location = jim.distance(from: CLocation)
        
        circ.map = self.vwGMap
        self.view = self.vwGMap
    }
    */
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
        self.marker.map = nil
        detailsPopUp.removeFromSuperview()
        self.place = place
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        self.vwGMap.camera = camera
        //it appends markers rather than removing them
      let marker = GMSMarker()
      self.marker = marker
        marker.position = CLLocationCoordinate2DMake(place.coordinate.latitude, place.coordinate.longitude)
        marker.accessibilityValue = place.name
        marker.map = self.vwGMap
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        self.dismiss(animated: true, completion: nil)
  
        self.newPlaceName = place.name
        var newPlaceNameText:String = "\(newPlaceName)"
        self.newPlaceNameText = "\(newPlaceName)"
        self.newPlaceAddress = place.formattedAddress!
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
        nameWhenAddingPlace.text = newPlaceNameText
        AddNewPlaceButton.isUserInteractionEnabled = false
        AddNewPlaceButton.setTitleColor(UIColor.gray, for: .normal)
        self.vwGMap.addSubview(mapCustomInfoWindow)
        self.vwGMap.addSubview(dropDownMenuFolder)
        mapCustomInfoWindow.layer.borderWidth = 2
        mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
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
                        AddNewPlaceButton.isUserInteractionEnabled = false
                        AddNewPlaceButton.setTitleColor(UIColor.gray, for: .normal)
            mapCustomInfoWindow.center = mapView.projection.point(for: tappedMarker)
            mapCustomInfoWindow.center.y -= 150
        
            mapCustomInfoWindow.layer.borderWidth = 2
            mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
            self.vwGMap.addSubview(mapCustomInfoWindow)
          self.vwGMap.addSubview(dropDownMenuFolder)
        } else {
                    
                    if (marker.userData as! markerUserData).websiteUserData == "" {
                        websiteButton.isHidden = true
                        print("there is nothing in the website")
                    } else {
                        tappedMarkerWebsite = (marker.userData as! markerUserData).websiteUserData
                        websiteButton.isHidden = false
                         print("there is definately a website")
                    }
                    
                    if (marker.userData as! markerUserData).telephoneUserData == "" {
                     telephoneButton.isHidden = true
                    } else {
                        tappedMarkerTelephone = (marker.userData as! markerUserData).websiteUserData
                        telephoneButton.isHidden = false
                    }
                    
                    
                        moreDetailButton.setTitleColor(UIColor.red, for: .normal)
                        closeDetailsButton.setTitleColor(UIColor.red, for: .normal)
                   
                        ratingControl.isHidden = false
            detailsName.text = (marker.userData as! markerUserData).nameUserData
            self.firebaseKey = (marker.userData as! markerUserData).firebaseKey
            ratingControl.firebaseKey = firebaseKey
                       //  print("inside tapped")
    if self.ratingControlRating != (marker.userData as! markerUserData).rating  {
        ratingControl.rating = (marker.userData as! markerUserData).rating
    } else {
         ratingControl.rating = self.ratingControlRating }
            if (marker.userData as! markerUserData).firebaseKey == "" {
                      ratingControl.isUserInteractionEnabled = false
                print("nofirebasekey")
                shareButton.isHidden = true
                addToNewFolderButtonInPopUp.isHidden = false
                    }
        addToNewFolderButtonInPopUp.isHidden = true
        shareButton.isHidden = false
        updaterating = (marker.userData as! markerUserData).rating
        checkboxBool = (marker.userData as! markerUserData).checkbox
        tagsMarker = (marker.userData as! markerUserData).tags
       // websiteLabel.text = (marker.userData as! markerUserData).websiteUserData
        markerPlacePictureURL = (marker.userData as! markerUserData).placepicture
        tappedMarkerTelephone = (marker.userData as! markerUserData).telephoneUserData
                       // print(tappedMarkerTelephone)
        tappedMarkerAddress = (marker.userData as! markerUserData).addressUserData
        detailsPopUp.layer.borderWidth = 2
        detailsPopUp.layer.borderColor = UIColor.darkGray.cgColor
        getImage(imageName:(marker.userData as! markerUserData).firebaseKey )
          self.vwGMap.addSubview(detailsPopUp)
        }
        return false
    }
  
    func getImage(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            pictureOfPlace.image = UIImage(contentsOfFile: imagePath)
            pictureOfPlace.layer.borderWidth = 1
            pictureOfPlace.layer.masksToBounds = false
            pictureOfPlace.layer.borderColor = UIColor.orange.cgColor
            pictureOfPlace.layer.cornerRadius = pictureOfPlace.frame.height/2
            pictureOfPlace.clipsToBounds = true
            pictureOfPlace.isHidden = false
          //  print("I have uploaded image from internal database")
        }else{
            //if there is no image added to the place then rearrange the detail view to look good without the little picture
            pictureOfPlace.isHidden = true
        }
    }

    
    //This produces the coordinate of where it tapped on the map, doesn't work on tapped markers
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
     print(String(coordinate.latitude))
     print(String(coordinate.longitude))
     }
     */
    
    //This prints out the details just by clicking on a place need to enable this
    func mapView(_ mapView: GMSMapView, didTapPOIWithPlaceID placeID: String, name: String, location: CLLocationCoordinate2D) {
  
        vwGMap.animate(to: GMSCameraPosition.camera(withTarget: location, zoom: 10.0))
       self.marker.map = nil
        let marker = GMSMarker()
       
        self.marker = marker
        marker.position = location
        tappedMarker = location
        marker.map = self.vwGMap
        mapCustomInfoWindow.layer.borderWidth = 2
        mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
        self.vwGMap.addSubview(mapCustomInfoWindow)
        self.vwGMap.addSubview(dropDownMenuFolder)
        
 marker.icon = GMSMarker.markerImage(with: UIColor.blue)
self.newPlacePlaceID = placeID
      //  print(placeID)
       // print(self.newPlacePlaceID)
       // print(name)
    self.newPlaceNameText = name
        nameWhenAddingPlace.text = name
    
        lookUpPlaceID()
               }

    func lookUpPlaceID () {
  
         var Place:GMSPlace?
        self.placesClient.lookUpPlaceID(self.newPlacePlaceID, callback: { (placeID, error) -> Void in
            if let error = error {
                
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            guard let place = Place else {
                print("No place details for \(placeID)")
                
                self.newPlaceAddress = (placeID?.formattedAddress)!
                let newPlaceLongitude = (placeID?.coordinate.longitude)!
                var longitudeText:String = "\(newPlaceLongitude)"
                self.longitudeText = "\(newPlaceLongitude)"
                
                let newPlaceLatitude = (placeID?.coordinate.latitude)!
                var latitudeText:String = "\(newPlaceLatitude)"
                self.latitudeText = "\(newPlaceLatitude)"
                var telephone = placeID?.phoneNumber
                if telephone == nil {
                    self.telephone = ""
                } else {
                    self.telephone = telephone!
                }
                
                var website =  placeID?.website
                //this doesnt really save the website
                if website == nil {
                    self.website = ""
                    print("THERE IS NO WEBSITE")
                } else {
                    var newWebsite = website!
                    self.website = "\(newWebsite)"
                    print("THERE IS A WEBSITE")
                }
            
                return
            }
            
        })
    }

   
    
    //This is so that the addPlace window tacks onto place with marker
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
       detailsPopUp.center = mapView.projection.point(for: tappedMarker)
       detailsPopUp.center.y -= 150
        mapCustomInfoWindow.center = mapView.projection.point(for: tappedMarker)
        mapCustomInfoWindow.center.y -= 150
    dropDownMenuFolder.frame.origin.x = mapCustomInfoWindow.center.x-dropDownMenuFolder.frame.width/2
    dropDownMenuFolder.frame.origin.y = mapCustomInfoWindow.center.y-30
    }

    
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
        var post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "StoredPlaceAddress" : PlaceAddress as AnyObject, "StoredPlaceWebsite" : PlaceWebsite as AnyObject, "StoredPlaceTelephone" : PlaceTelephone as AnyObject,  "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : LongitudeCoordinate as AnyObject, "Latitude" : LatitudeCoordinate as AnyObject, "Rating" : 0 as AnyObject, "Tags" : "" as AnyObject, "Checkbox" : false as AnyObject, "StoredPlacePicture": "" as AnyObject ]
        
        let databaseRef = Database.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
     
        marker.icon = UIImage(named: FolderIcon )
        mapCustomInfoWindow.removeFromSuperview()
        //this drop down menu does not appear after opening the window once
        dropDownMenuFolder.removeFromSuperview()
      //  detailsPopUp.removeFromSuperview()
        let when = DispatchTime.now() + 2
    DispatchQueue.main.asyncAfter(deadline: when) {
           
    self.moreDetailButton.setTitleColor(UIColor.red, for: .normal)
    self.closeDetailsButton.setTitleColor(UIColor.red, for: .normal)
         //   print((self.MARKers.last?.userData as! markerUserData).firebaseKey)
         //   self.websiteLabel.isHidden = false
        
            self.ratingControl.isHidden = false
            self.detailsName.text = (self.MARKers.last?.userData as! markerUserData).nameUserData
            self.firebaseKey = (self.MARKers.last?.userData as! markerUserData).firebaseKey
            self.ratingControl.firebaseKey = self.firebaseKey
            print("inside tapped")
            if self.ratingControlRating != (self.MARKers.last?.userData as! markerUserData).rating  {
                self.ratingControl.rating = (self.MARKers.last?.userData as! markerUserData).rating
            } else {
                self.ratingControl.rating = self.ratingControlRating }
       
            self.updaterating = (self.MARKers.last?.userData as! markerUserData).rating
            self.checkboxBool = (self.MARKers.last?.userData as! markerUserData).checkbox
            self.tagsMarker = (self.MARKers.last?.userData as! markerUserData).tags
        //    self.websiteLabel.text = (self.MARKers.last?.userData as! markerUserData).websiteUserData
        print((self.MARKers.last?.userData as! markerUserData).websiteUserData)
            self.markerPlacePictureURL = (self.MARKers.last?.userData as! markerUserData).placepicture
            self.tappedMarkerTelephone = (self.MARKers.last?.userData as! markerUserData).telephoneUserData
           
            self.tappedMarkerAddress = (self.MARKers.last?.userData as! markerUserData).addressUserData
         
            
            self.getImage(imageName:(self.MARKers.last?.userData as! markerUserData).firebaseKey)
      
            self.detailsPopUp.layer.borderWidth = 2
            self.detailsPopUp.layer.borderColor = UIColor.darkGray.cgColor
            self.vwGMap.addSubview(self.detailsPopUp)
        }
     /*
       let beforeFirebase = STOREDPlaces.count
    
        let ref = Database.database().reference().child((user?.uid)!).child("StoredPlaces")
        
        ref.observe( .childAdded, with: { (snapshot) in
          //  STOREDPlaces.removeAll()
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
               let key = snapshot.key
              //  for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                    //    let key = snap.key
                   //     self.firebaseKey = key
                        var PLACE = (dictionary as? [String: AnyObject]!)!
                        PLACE?.updateValue(key as AnyObject, forKey: "firebaseKey")
                        STOREDPlaces.append(PLACE!)
                        self.filterPlaces()
                    }
                }
                
            }
    //    }
        )
 */
      /*
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.filterPlaces()
            print("after firebase")
            print(STOREDPlaces.count)
            self.afterfirebase = STOREDPlaces.count
           
            if beforeFirebase == self.afterfirebase {
                print("before and after are equal")
                post.updateValue("" as AnyObject, forKey: "firebaseKey")
                STOREDPlaces.append(post)
                self.filterPlaces()
            } else {
                print("before and after firebase not equal")
                
            }
   
       
        }
    */
    }

    //This is the cancel button in when a user is asked to add a new place
    @IBAction func CancelAddNewPlace(_ sender: Any) {
        mapCustomInfoWindow.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
        detailsPopUp.removeFromSuperview()
    }
    
    @IBAction func detailCloseAction(_ sender: Any) {
     //   self.filterSelected = "All"
       // filterPlaces()
     detailsPopUp.removeFromSuperview()
    }
    
    @IBAction func detailMoreDetailAction(_ sender: Any) {
      print("more detail button is being tapped")
    }
    func userDidEnterInformation(info: String) {
        print(info)
        tagsMarker = info
    }
    func userDidChangePhoto(info2: UIImage) {
    }
    func userDidChangeRating(info3: Int) {
       selectedPlace.updateValue(info3 as AnyObject, forKey: "Rating")
        ratingControl.rating = info3
        print(info3)
        updaterating = info3
    }
    func userDidChangeCheckbox(info4: Bool) {
        selectedPlace.updateValue(info4 as AnyObject, forKey: "Checkbox")
        checkboxBool = info4
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let controller = segue.destination as! ThirdViewController
//       controller.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
//        controller.modalPresentationStyle = .custom
     //   controller.delegate = self
      //  let drinks = STOREDPlaces.map({$0["Tags"]})
    
       
        var markerDict = ["StoredPlaceName": detailsName.text, "Rating": ratingControl.rating, "firebaseKey" : firebaseKey, "Checkbox" : checkboxBool, "Tags" : tagsMarker, "StoredPlacePicture" : markerPlacePictureURL, "StoredPlaceAddress" : tappedMarkerAddress,  "StoredPlaceTelephone": tappedMarkerTelephone] as [String : Any]
        //"StoredPlaceWebsite": websiteLabel.text,
       selectedPlace = markerDict as [String : AnyObject]
    //   ratingControl.selectedPlaceDetail = markerDict as [String : AnyObject]
        
      /*  if (segue.identifier == "testingSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! ThirdViewController
        }
 */
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
        if updaterating != ratingControlRating {
            print("no match")
        } else {
            print("match")
        }
        //self.view.addSubview(detailsPopUp)
   
        transition.bubbleColor = moreDetailButton.backgroundColor!
        return transition
    }
    
    @IBAction func websiteButtonAction(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: tappedMarkerWebsite)! as URL)
    }
    
    @IBAction func telephoneButtonAction(_ sender: Any) {
        let phoneCallURL = URL(string: "tel://\(tappedMarkerTelephone)")
            UIApplication.shared.openURL(phoneCallURL!)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
   friendSlider2.frame = CGRect(x: 0, y: friendSlider.frame.minY, width: self.view.frame.width, height: friendSlider.frame.height)
       friendSlider.isHidden = true
        self.view.addSubview(friendSlider2)
    }
   
    func fetchFolder() {
        
        let ref = Database.database().reference().child((user?.uid)!).child("UserFolders")
        
        ref.observe( .value, with: { (snapshot) in
            var rmIndices = [Int]()
    STOREDFolders.removeAll()
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
            let addButton = FILTER()
            addButton.name = "Add"
            addButton.icon = "AddIcon"
            addButton.type = "addButton"
            addButton.key = ""
            allFolders.append(addButton)
            let allFilter = FILTER()
            allFilter.name = "All"
            allFilter.icon = "0"
            allFilter.type = "folder"
            allFilter.key = ""
            allFolders.append(allFilter)
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
                        allFolders.append(folder)
                        var FOLDER = (dictionary[key] as? [String: AnyObject]!)!
                        FOLDER?.updateValue(key as AnyObject, forKey: "firebaseKey")
                        STOREDFolders.append(FOLDER!)
                    }
                }
                self.allFilters = allFolders + self.allFilters
                // if self.folders.contains(folder) {
                // print("YES")
                //}
                DispatchQueue.main.async {
                  //  self.friendSlider.reloadData()
                    print("This should print at the end of completed task ")
                    
                }
            }
                self.setupInIt()
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
                        self.friendsForSlider2.append(friendFilter)
                        
        
                        
                        allFriends.append(friend)
                        // let friend = (dictionary[key] as? [String: AnyObject]!)!
                        print("this is the firebase all friends func\(allFriends.count)")
                        // snapKeys.append(key)
                        // friends.updateValue(key as AnyObject, forKey: "firebaseKey")
                        
                    }
                    
                    
                }
                self.allFilters = self.allFilters + self.friendsForSlider2
                DispatchQueue.main.async {
                    self.friendSlider.reloadData()
                    self.friendSlider2.reloadData()
                    print("This should print at the end of completed task ")
                    
                }
                
                if allFriends.count > 0 {
                    print("this is AFTER all friends has been populated\(allFriends.count)")
                    let user = USER()
                    
                    for friend in allFriends {
                        
                        let ref = Database.database().reference().child(friend.AuthFirebaseKey!).child("StoredPlaces")
                        ref.observe( .value, with: { (snapshot) in
                            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                                for snap in snapshots {
                                    if let dictionary = snapshot.value as? [String: AnyObject] {
                                        let key = snap.key
                                        
            friend.StoredPlacesOfUser.append((dictionary[key] as? [String: AnyObject]!)!)
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
    
 
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.friendSlider2 {
            print("This is the second slider")
            print(friendsForSlider2.count)
            return friendsForSlider2.count
        }
 
        //print("HELLO HELLO")
        print(allFilters.count)
        return allFilters.count
    }

   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if collectionView == self.friendSlider {
            let filter = allFilters[indexPath.row]
            let cellA = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            
            cellA.friendProfileImageFromMap.image = UIImage(named: "funProfileIcon")
            let gradient: CAGradientLayer = CAGradientLayer()
          
            
            var borderColor: CGColor! = UIColor.clear.cgColor
            var borderWidth: CGFloat = 0
            
           
           if indexPath.row == selectedRowIndex {
            
                borderWidth = 1.7 //or whatever you please
            borderColor = UIColor.orange.cgColor
           // gradient.colors = [
           //     UIColor.green.cgColor,
            //    UIColor.black.cgColor
           // ]
          gradient.locations = [0.5, 1.0]
            }else{
                borderColor = UIColor.clear.cgColor
                borderWidth = 0
    
         
            }
            cellA.friendProfileImageFromMap.layer.borderColor = borderColor
         cellA.friendProfileImageFromMap.layer.borderWidth = borderWidth
           
            
            if filter.type == "folder" {
                // let scale1x = UITraitCollection(displayScale: 1.0)
              // let image = UIImage(named: filter.icon!)?.imageAsset?.image(with: scale1x)
                cellA.friendProfileImageFromMap.image = UIImage(named: filter.icon!)
               cellA.friendProfileImageFromMap.contentMode = UIViewContentMode.scaleAspectFit
                cellA.friendProfileImageFromMap.clipsToBounds = true
            } else if filter.type == "friend" {
                let fileManager = FileManager.default
                
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filter.path!)
              //  print(imagePath)
                if fileManager.fileExists(atPath: imagePath){
                    cellA.friendProfileImageFromMap.image = UIImage(contentsOfFile: imagePath)
                   
                    print("I have uploaded image from internal database")
                }else{
                    print("Panic! No Image!")
                    cellA.friendProfileImageFromMap.image = UIImage(named: "funProfileIcon")
                }
            } else if filter.type == "addButton" {
                print("This is doing the addIcon image")
                cellA.friendProfileImageFromMap.image = UIImage(named: "addIcon")
            }
            cellA.nameForLabelMap.text = filter.name
         
            return cellA
        }
            
        else {
            let cellB = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell2", for: indexPath) as! CollectionViewCell2
            let friend = friendsForSlider2[indexPath.row]
             print("this is prnting the filter\(friend)")
            var borderColor: CGColor! = UIColor.clear.cgColor
            var borderWidth: CGFloat = 0
            if indexPath.row == selectedRowIndex {
                borderColor = UIColor.orange.cgColor
                borderWidth = 1.7 //or whatever you please
                print("There is a match between the indexpath and selected index")
            }else{
                borderColor = UIColor.clear.cgColor
                borderWidth = 0
                print("There is no match")
                
            }
            cellB.viewForBorderCollectionView2.layer.borderColor = borderColor
            cellB.viewForBorderCollectionView2.layer.borderWidth = borderWidth
            //cellB.profilePicForSlider2.layer.borderWidth = borderWidth
           // cellB.profilePicForSlider2.layer.borderColor = borderColor
            
           cellB.nameLabelForSlider2.text = friend.name
            let fileManager = FileManager.default
            
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(friend.path!)
           // print(imagePath)
            if fileManager.fileExists(atPath: imagePath){
                cellB.profilePicForSlider2.image = UIImage(contentsOfFile: imagePath)
                print("I have uploaded image from internal database")
            }else{
                print("Panic! No Image!")
                cellB.profilePicForSlider2.image = UIImage(named: "funProfileIcon")
            }

            
            return cellB
        }
        
   
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.friendSlider {
         let filter = allFilters[indexPath.row]
            selectedRowIndex = indexPath.row
            //friendSlider.reloadData()
          // print(filter.type)
        if filter.type == "folder" {
            filterSelected = filter.name!
            filterPlaces()
        } else if filter.type == "friend" {
            for friend in allFriends {
                if filter.path == friend.AuthFirebaseKey {
                    self.marker.map = nil
                    self.vwGMap.clear()
                        for place in friend.StoredPlacesOfUser {
                            
                            let latitude = (place["Latitude"] as? NSString)?.doubleValue
                            let longitude = (place["Longitude"] as? NSString)?.doubleValue
                            
                            let markers = GMSMarker()
                            markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
                            //let folderIcon = friend.StoredPlacesOfUser[key]?["FolderIcon"] as? String
                           // self.markersArray.append(markers.position)
                            
                            markers.icon = UIImage(named:"0")
                            markers.tracksViewChanges = true
                            markers.map = self.vwGMap
                        vwGMap.camera = GMSCameraPosition.camera(withTarget: markers.position, zoom: 7.0)
                    
                            let name = (place as? [String: AnyObject]!)!["StoredPlaceName"]
                            let website = (place as? [String: AnyObject]!)!["StoredPlaceWebsite"]
                            let address = (place as? [String: AnyObject]!)!["StoredPlaceAddress"]
                            let rating = (place as? [String: AnyObject]!)!["Rating"]
                            let checkbox = (place as? [String: AnyObject]!)!["Checkbox"]
                            let tags = (place as? [String: AnyObject]!)!["Tags"]
                            let placePicture = (place as? [String: AnyObject]!)!["StoredPlacePicture"]
                            let telephone = (place as? [String: AnyObject]!)!["StoredPlaceTelephone"]
                            let foldername = (place as? [String: AnyObject]!)!["PlaceUnderFolder"]
                            let key = ""
                            
                            markers.accessibilityValue = name as! String
                            
                            self.placeNamesArray.append(name! as! String)
                            
                            
                            let storedPlaceUserData = markerUserData(Name: name! as! String, Address: address! as! String, Website: website! as! String, Telephone: telephone! as! String, FirebaseKey: key, Rating: rating! as! Int, Checkbox: checkbox! as! Bool, Tags: tags! as! String, PlacePicture: placePicture! as! String, FolderName: foldername as! String)
                            
                            markers.userData = storedPlaceUserData

                    }
                    }
            }

            } else if filter.type == "addButton" {
              // self.performSegue(withIdentifier: "testingSegue" , sender: self)
            self.definesPresentationContext = true
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
                
                self.present(vc, animated: true, completion: nil)
            }
 
        } else if collectionView == self.friendSlider2 {
       // print("I am selecting something from the friend slider 2")
           // let cell = collectionView.cellForItem(at: indexPath)
            let filter = friendsForSlider2[indexPath.row]
            selectedRowIndex = indexPath.row
            friendSlider2.reloadData()
            vwGMap.addSubview(popSliderViewWindow)
            userToSendRecommendationTo = filter
        }
 
 
        }



    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
       // print("size if cell called ")
 
        var size = CGSize(width: 55, height: 80)
        
        return size
    }
    
    
    @IBAction func addToNewFolderButtonInPopUpAction(_ sender: Any) {
        let post = ["FriendUsername" : userToSendRecommendationTo.name, "FriendProfilePicture" : userToSendRecommendationTo.path, "FriendSendingMessage" : messageToFriendTextField.text, "FriendRecommendedPlaceName" : detailsName.text ]
        
     //    var markerDict = ["StoredPlaceName": detailsName.text, "Rating": ratingControl.rating, "firebaseKey" : firebaseKey, "Checkbox" : checkboxBool, "Tags" : tagsMarker, "StoredPlacePicture" : markerPlacePictureURL, "StoredPlaceAddress" : tappedMarkerAddress,  "StoredPlaceTelephone": tappedMarkerTelephone] as [String : Any]
        let databaseRef = Database.database().reference()
        databaseRef.child(userToSendRecommendationTo.path!).child("FriendMessages").childByAutoId().setValue(post)
        
    }
    
    @IBAction func sendToFriendRecommendation(_ sender: Any) {
        let post = ["FriendUsername" : userToSendRecommendationTo.name, "FriendProfilePicture" : userToSendRecommendationTo.path, "FriendSendingMessage" : messageToFriendTextField.text, "FriendRecommendedPlaceName" : detailsName.text ]
        
        //    var markerDict = ["StoredPlaceName": detailsName.text, "Rating": ratingControl.rating, "firebaseKey" : firebaseKey, "Checkbox" : checkboxBool, "Tags" : tagsMarker, "StoredPlacePicture" : markerPlacePictureURL, "StoredPlaceAddress" : tappedMarkerAddress,  "StoredPlaceTelephone": tappedMarkerTelephone] as [String : Any]
        let databaseRef = Database.database().reference()
        databaseRef.child(userToSendRecommendationTo.path!).child("FriendMessages").childByAutoId().setValue(post)
        popSliderViewWindow.removeFromSuperview()
        friendSlider2.removeFromSuperview()
        detailsPopUp.removeFromSuperview()
        self.view.addSubview(friendSlider)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        
        self.present(vc, animated: true, completion: nil)
    }
    
    


}
