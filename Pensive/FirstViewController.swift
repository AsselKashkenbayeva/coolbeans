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




var firebaseStoredPlaces: [placeFromFirebase] = []
var STOREDPlaces = [[String:AnyObject]]()
var STOREDFolders = [[String:AnyObject]]()
var itemIndex = Int()
class placeFromFirebase: NSObject {
    
    var name: String?
    var address: String?
    var telephone: String?
    var folderIcon: String?
    var latitude: String?
    var longitude: String?
}


class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate, IGLDropDownMenuDelegate {
    
    
    
    //Container for viewing Gmaps
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    var Markers = [GMSMarker]()
    
    
    @IBOutlet var detailsPopUp: UIView!
    
    @IBOutlet weak var detailsName: UILabel!
    
    @IBOutlet var detailWebsite: UILabel!
    
    @IBOutlet weak var detailRatingControl: RatingControl!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet var mapCustomInfoWindow: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var AddNewPlaceButton: UIButton!
    
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
    var newPlaceTelephone = ""
    //   var newPlaceWebsite = ""
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
    
    var storedPlaceNamefromFirebase = ""
    var bloBB = [String]()
    var storedPlaceLatitude = ""
    var storedPlaceLongitude = ""
    
    var user = FIRAuth.auth()?.currentUser
    var databaseRef = FIRDatabase.database().reference()
    
    var effect:UIVisualEffect!
    var blob = placeFromFirebase()
    var dropDownMenuFolder = IGLDropDownMenu()
    var dataTitle: NSArray = ["Restaurant", "Museum", "Landmarks", "Favourites"]
    var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!]
    var Folders = [String]()
    var Names = [String]()
    var NK = [String]()
    var tappedMarker = CLLocationCoordinate2D()
    var folderNames = [String]()
    var markersArray = [CLLocationCoordinate2D]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dont forget to set trackchanges for updates to the info window
        
        fetchFolders()
        
        
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
        
        /*   // Google Maps Directions
         GoogleMapsDirections.provide(apiKey: "AIzaSyC-i5xPkUJ9yObNcwhGRjBYI8Q_wNsWZr4")
         let origin = GoogleMapsDirections.Place.placeID(id: "ChIJxc4vk9QEdkgRjJ2al7_P9uw")
         let destination = GoogleMapsDirections.Place.placeID(id: "ChIJb9sw59k0K4gRZZlYrnOomfc")
         
         GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
         
         guard response?.status == GoogleMapsDirections.StatusCode.ok else {
         debugPrint(response?.errorMessage)
         return
         }
         */
        
        
        //}
        //let mapView = GMSMapView.map(withFrame:  .zero, camera: camera)
        // mapView.settings.myLocationButton = true
        // mapView.delegate = self
        
        let ref = FIRDatabase.database().reference().child((user?.uid)!).child("StoredPlaces")
        
        ref.observe( .value, with: { (snapshot) in
            STOREDPlaces.removeAll()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        let PLACE = (dictionary[key] as? [String: AnyObject]!)!
                        STOREDPlaces.append(PLACE!)
                      
                    }
                }
              
                self.markersArray.removeAll()
                for p in STOREDPlaces {
                    let latitude = (p["Latitude"] as? NSString)?.doubleValue
                    let longitude = (p["Longitude"] as? NSString)?.doubleValue
                    let markers = GMSMarker()
                    markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
                    
                    self.markersArray.append(markers.position)
                    let folderIcon = p["FolderIcon"] as? String
                    markers.icon = UIImage(named:folderIcon!)
                    markers.tracksViewChanges = true
                    //this does not match which place was tapped
                    self.detailsName.text = p["StoredPlaceName"] as? String
                    markers.map = self.vwGMap
                }
            }
        }
        )
        
        let refFolders = FIRDatabase.database().reference().child((user?.uid)!).child("UserFolders")
        
        refFolders.observe( .value, with: { (snapshot) in
            STOREDFolders.removeAll()
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when) {
        
            self.folderNames.removeAll()
            for r in STOREDFolders  {
                let folder = r["FolderName"] as? String
                
                self.folderNames.append(folder!)
                
            }
            self.setupInIt()
            self.sortByDropDown()
        }
        
    }
    
  
    
    func sortByDropDown() {
        let items = self.folderNames
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Sort By", items: items as [AnyObject])
        menuView.updateItems(self.folderNames as [AnyObject])
        self.navigationItem.titleView = menuView
        menuView.cellTextLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        menuView.menuTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        menuView.cellSelectionColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
           print(self?.folderNames[indexPath])
            
        }
        
        
    }
    
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
    
    //This is setting up the dropdown menu in the add new place pop up
    func setupInIt() {
        
        let dropdownItems: NSMutableArray = NSMutableArray()
        if STOREDFolders.count > 0 {
            for i in 0...(STOREDFolders.count-1) {
                let item = IGLDropDownItem()
                item.text = (STOREDFolders[i]["FolderName"] as! String!)
                item.iconImage = UIImage(named: STOREDFolders[i]["FolderIcon"] as! String!)
                dropdownItems.add(addObject:item)
            }
        }
        else {
            
        }
        
        
        
        
        dropDownMenuFolder.menuText = "Choose Folder"
        dropDownMenuFolder.dropDownItems  = dropdownItems as [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
        dropDownMenuFolder.frame = CGRect(x: 85, y: 120, width: 200, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.stack
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
        
        let myLabel = UILabel()
        myLabel.text = "SwiftyOS Blog"
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.frame = CGRect(x: 40, y: 60, width: 200, height: 45)
        
        self.mapCustomInfoWindow.addSubview(myLabel)
        mapCustomInfoWindow.addSubview(dropDownMenuFolder)
    }
    
    //This is delegate for what is selected in dropdown menu when adding new place
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        let item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        let folderItem = item.text
        self.folderItem = folderItem!
        let folderIconIndex = String(item.index)
        self.folderIconIndex = folderIconIndex
        
    }
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
        
        self.view = self.vwGMap }
    
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
        marker.title = place.name
        marker.snippet = place.formattedAddress
        marker.map = self.vwGMap
        marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        self.dismiss(animated: true, completion: nil)
        
        let newPlaceName = place.name
        self.newPlaceName = place.name
        var newPlaceNameText:String = "\(newPlaceName)"
        self.newPlaceNameText = "\(newPlaceName)"
        let newPlaceAddress = place.formattedAddress
        self.newPlaceAddress = place.formattedAddress!
        let newPlacePlaceID = place.placeID
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
        
        detailsPopUp.center = mapView.projection.point(for: tappedMarker)
        detailsPopUp.center.y -= 100
        self.view.addSubview(detailsPopUp)
        
        for i in 0...(markersArray.count-1) {
            if  markersArray[i].latitude == tappedMarker.latitude &&  markersArray[i].longitude == tappedMarker.longitude
            {
                print(i)
                detailsName.text = STOREDPlaces[i]["StoredPlaceName"] as? String
                detailWebsite.text = STOREDPlaces[i]["StoredPlaceWebsite"] as? String
                itemIndex = i
                //if picture of person who it is taken from
               
            } else {
                
            }
            
        }
        
        detailImageView.image = UIImage(named: "b")
        
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
        
        let location = marker.position
        
        //  addNewItem.center = mapView.projection.point(for: location)
        //detailsPopUp.center = mapView.projection.point(for: )
        detailsPopUp.center = mapView.projection.point(for: tappedMarker)
        detailsPopUp.center.y -= 110
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
        dropDownMenuFolder.center = mapView.projection.point(for: location)
        dropDownMenuFolder.center.y -= 150
    }
    
    
    //When doing long press, it shows pop up window above icon
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        
        let location = marker.position
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
        
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
        let post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "StoredPlaceAddress" : PlaceAddress as AnyObject, "StoredPlaceWebsite" : PlaceWebsite as AnyObject, "StoredPlaceTelephone" : PlaceTelephone as AnyObject,  "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : LongitudeCoordinate as AnyObject, "Latitude" : LatitudeCoordinate as AnyObject ]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
        
        marker.icon = UIImage(named: FolderIcon )
        mapCustomInfoWindow.removeFromSuperview()
        //this drop down menu does not appear after opening the window once
        dropDownMenuFolder.removeFromSuperview()
        mapCustomInfoWindow.layer.borderWidth = 2
        mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
         
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
        
    }
    
}

