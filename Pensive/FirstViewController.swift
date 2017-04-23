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

import CoreData

import Firebase
import FirebaseDatabase
import FirebaseAuth

import BTNavigationDropdownMenu
import IGLDropDownMenu



var storedPlaces: [NSManagedObject] = []
var firebaseStoredPlaces: [placeFromFirebase] = []
var STOREDPlaces = [[String:AnyObject]]()
var STOREDFolders = [[String:AnyObject]]()
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

    @IBOutlet var mapCustomInfoWindow: UIView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var AddNewPlaceButton: UIButton!
    
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
    var newPlaceTelephone = ""
    var newPlaceWebsite = ""
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
    var aaa = "AAAA"
   var Folders = [String]()
   var Names = [String]()
 var NK = [String]()
    var tappedMarker = GMSMarker()
    
override func viewDidLoad() {
    super.viewDidLoad()
   /* fetchPlace(completion: { (Place) in

        let place = Place
       // print(place.name!)
        self.Names.append(place.name!)
        
       // print(self.Names[5])
     
    })
 */
//dont forget to set trackchanges for updates to the info window
    /*
        let latitude = (place.latitude! as NSString).doubleValue
        print(latitude)
        let longitude = (place.longitude! as NSString).doubleValue
        print(longitude)
        let markers = GMSMarker()
        markers.position = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
        markers.icon = UIImage(named: place.folderIcon!)
        markers.userData = place
        markers.tracksViewChanges = true
    let name = (markers.userData as! placeFromFirebase).name
        self.placeNameinDetailsPopUp.text = name
        self.Names.append(name!)
       
    }
 
 */
    
    //print(self.NK)
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
    /*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredPlace")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            storedPlaces = results as! [NSManagedObject]
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let name = result.value(forKey: "name") as? String
                    {
                       print(name)
                    }
                    if let address = result.value(forKey: "address") as? String
                    {
                       // print(address)
                    }
                    if let placeID = result.value(forKey: "placeID") as? String
                    {
                      //  print(placeID)
                    }
                
                        
            
                  
                    if let lat = result.value(forKey: "latitude") as? NSString, let long = result.value(forKey: "longitude") as? NSString, let address = result.value(forKey: "address") as? String, let name = result.value(forKey: "name") as? String
                    {
               */
                        
    let ref = FIRDatabase.database().reference().child((user?.uid)!).child("StoredPlaces")
                        
    ref.observe( .value, with: { (snapshot) in
     if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
        for snap in snapshots {
             if let dictionary = snapshot.value as? [String: AnyObject] {
            let key = snap.key
                let PLACE = (dictionary[key] as? [String: AnyObject]!)!
          STOREDPlaces.append(PLACE!)
               
        }
        }
      
   
        for p in STOREDPlaces {
            let latitude = (p["Latitude"] as? NSString)?.doubleValue
            let longitude = (p["Longitude"] as? NSString)?.doubleValue
            let markers = GMSMarker()
            markers.position = CLLocationCoordinate2D(latitude: latitude! , longitude: longitude!)
            let folderIcon = p["FolderIcon"] as? String
            markers.icon = UIImage(named:folderIcon!)
          markers.tracksViewChanges = true
            markers.map = self.vwGMap
        }
            }
    }
    )
    let refFolders = FIRDatabase.database().reference().child((user?.uid)!).child("UserFolders")
    
    refFolders.observe( .value, with: { (snapshot) in
        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshots {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    // STOREDPlaces = dictionary
                    let key = snap.key
                    print(key)
                    let FOLDER = (dictionary[key] as? [String: AnyObject]!)!
                    STOREDFolders.append(FOLDER!)
                    
                }
            }
        }
    }
    )
    
 
//This is the drop down in the navigation bar to sort through markers on map
    var logoImages = [UIImage]()
    logoImages.append(UIImage(named: "MapIcon")!)
        let items = Folders
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Sort By", items: items as [AnyObject])
        
    self.navigationItem.titleView = menuView
    menuView.cellTextLabelColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    menuView.menuTitleColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    menuView.cellSelectionColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            
            for i in 0...(items.count-1) {
                menuView.arrowImage = self?.dataImage[i]
                menuView.checkMarkImage = self?.dataImage[i]
            }
        }
    let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
    DispatchQueue.main.asyncAfter(deadline: when) {
        // Your code with delay
     self.setupInIt()
      
       
    }
    
    }
    
         //Dropdown menu for the add new place pop up variables (folders)
    /*
    func fetchFolders(ref: FIRDatabaseReference, completion:(_ currentArray:[String])->()) {
           var currentDetails = [String]()
        let ref = FIRDatabase.database().reference().child((user?.uid)!).child("UserFolders")
        ref.observe( .childAdded, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                if let dictionary = snapshot.value
                    
                    as? [String: AnyObject] {
                    
                    
                    
                    let folder = (dictionary["FolderName"] as? String?)!
                    
                    currentDetails.append(folder!)
                }
            }
            self.currentArray = currentDetails
            completion(currentArray)
        })
    }
    */
    /*
func fetchPlace(completion: @escaping (placeFromFirebase) -> (Void)) {
    let ref = FIRDatabase.database().reference().child((user?.uid)!).child("StoredPlaces")
        ref.observe( .childAdded, with: { (snapshot) in
            
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                if let dictionary = snapshot.value as? [String: AnyObject] {
    let Place = placeFromFirebase()
    Place.name = (dictionary["StoredPlaceName"] as? String?)!
    Place.address = (dictionary["StoredPlaceAddress"] as? String?)!
    Place.telephone = (dictionary["StoredPlaceTelephone"] as? String?)!
    Place.latitude = (dictionary["Latitude"] as? String?)!
    Place.longitude = (dictionary["Longitude"] as? String?)!
    Place.folderIcon = (dictionary["FolderIcon"] as? String?)!
 DispatchQueue.main.async {   completion(Place)
                          }
                }
            }
          
        }
        )}
    
    */
    
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
    print(STOREDFolders.count)
            for i in 0...(STOREDFolders.count-1) {
                let item = IGLDropDownItem()
                item.text = (STOREDFolders[i]["FolderName"] as! String!)
                item.iconImage = UIImage(named: STOREDFolders[i]["FolderIcon"] as! String!)
                dropdownItems.add(addObject:item)

            }
 
    
    dropDownMenuFolder.menuText = "Choose Folder"
    dropDownMenuFolder.dropDownItems  = dropdownItems as [AnyObject]
    dropDownMenuFolder.paddingLeft = 15
    dropDownMenuFolder.frame = CGRect(x: 40, y: 60, width: 200, height: 45)
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
    var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
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
 
        //let newPlaceLatitude = place.coordinate.latitude
        let newPlaceLatitude = place.coordinate.latitude
        //print(newPlaceLatitude)
        var latitudeText:String = "\(newPlaceLatitude)"
        self.latitudeText = "\(newPlaceLatitude)"
        
        let newPlaceLongitude = place.coordinate.longitude
        //print(newPlaceLongitude)
       
        var longitudeText:String = "\(newPlaceLongitude)"
        self.longitudeText = "\(newPlaceLongitude)"
      
        let telephone = place.phoneNumber
        
        let openNowStatus = place.openNowStatus
        let priceLevel = place.priceLevel
        let types = place.types
        let website = place.website
        //self.newPlaceWebsite = website
    }
    
//Initiated if autocomplete failed
func viewController(_ viewcontroller: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    print("ERROR AUTO COMPLETE \(error)") }

//Initiated if autocomplete cancelled
func wasCancelled(_ viewController:GMSAutocompleteViewController) {
            self.dismiss(animated: true, completion: nil)   }
    
    //I don't think this works
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchWithAddress = GMSAutocompleteViewController()
        searchWithAddress.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "UK"
        self.locationManager.startUpdatingLocation()
        
    self.present(searchWithAddress, animated: true, completion: nil)
    }
    
/*    func save(){
//this function adds place to CoreData
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
let newPlace = NSEntityDescription.insertNewObject(forEntityName: "StoredPlace", into: context)
        
     newPlace.setValue(newPlaceName, forKeyPath: "name")
     newPlace.setValue(newPlaceAddress, forKeyPath: "address")
     newPlace.setValue(newPlacePlaceID
            , forKeyPath: "placeID")
     newPlace.setValue(latitudeText, forKeyPath: "latitude")
     newPlace.setValue(longitudeText, forKeyPath: "longitude")
     newPlace.setValue(telephone, forKey: "telephone")
     newPlace.setValue(openNowStatus, forKey: "opennowstatus")
     newPlace.setValue(types, forKey: "types")
     newPlace.setValue(priceLevel, forKey: "pricelevel")
     newPlace.setValue(website, forKey: "website")
    
        do
        {
            try context.save()
            print("SAVED")
        }
            //PROCESS ERROR
        catch  let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
 */
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      self.view.addSubview(detailsPopUp)
        print(STOREDPlaces)
       // let name = (marker.userData as! placeFromFirebase).name
       // self.placeNameinDetailsPopUp.text = name
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
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
       // addNewItem.center.y -= 150
    }
 
//This is setting the custom infoWindow

    /*func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = detailsPopUp
        return infoWindow
    }
 */
//When doing long press, it shows pop up window above icon
func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
    
        let location = marker.position
        
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
        
        self.view.addSubview(mapCustomInfoWindow)
      
    }
      //  let location = CLLocationCoordinate2D(latitude: (marker.userData as! location).lat, longitude: (marker.userData as! location).lon)
        
    
 
    @IBOutlet weak var CancelAddNewPlace: UIButton!

   //When adding new place, saves place to Firebase, changes icon to selected
    @IBAction func AddNewPlaceAction(_ sender: Any) {
        
        let PlaceName: String = self.newPlaceNameText
        let PlaceAddress: String = self.newPlaceAddress
        let PlaceTelephone: String = self.newPlaceTelephone
        let PlaceID = self.newPlacePlaceID
        let PlaceUnderFolder = self.folderItem
        let LongitudeCoordinate = self.longitudeText
        let LatitudeCoordinate = self.latitudeText
        let FolderIcon = self.folderIconIndex
        //this is not correct because it shows the whole array in one part
        let post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "StoredPlaceAddress" : PlaceAddress as AnyObject, "StoredPlaceTelephone" : PlaceTelephone as AnyObject, "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : LongitudeCoordinate as AnyObject, "Latitude" : LatitudeCoordinate as AnyObject ]
        
let databaseRef = FIRDatabase.database().reference()
databaseRef.child((self.user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
        
       marker.icon = UIImage(named: FolderIcon )
       mapCustomInfoWindow.removeFromSuperview()
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
        print("After cancel button")
        print(STOREDPlaces)
        mapCustomInfoWindow.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
    }
}
