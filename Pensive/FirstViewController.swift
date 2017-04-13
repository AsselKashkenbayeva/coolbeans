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


//var storedPlaces: [StoredPlace] = []
var storedPlaces: [NSManagedObject] = []
 
class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate, IGLDropDownMenuDelegate {
    
   
   
   //Container for viewing Gmaps
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    var Markers = [GMSMarker]()
    
    @IBOutlet var addNewItem: UIView!

    @IBOutlet var mapCustomInfoWindow: UIView!
    
    @IBAction func dismissPopup(_ sender: Any) {
        addNewItem.removeFromSuperview()
    }
  
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var AddNewPlaceButton: UIButton!
    
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
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

    var user = FIRAuth.auth()?.currentUser
    var databaseRef = FIRDatabase.database().reference()

    var effect:UIVisualEffect!
    
   var dropDownMenuFolder = IGLDropDownMenu()
    var dataTitle: NSArray = ["Restaurant", "Museum", "Landmarks", "Favourites"]
   var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!]
    
    @IBOutlet weak var placeNameinInfoView: UILabel!
   var Folders = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        fetchFolders()
    setupInIt()
   print(Folders)
              // self.view = dropDownMenuFolder
        // removes the navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // this is for the sort by drop down menu
        effect = visualEffectView?.effect
        visualEffectView?.isHidden = true
        visualEffectView?.effect = nil
        addNewItem.layer.cornerRadius = 5
  

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
                        
    ref.observe( .childAdded, with: { (snapshot) in
    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                
    if let dictionary = snapshot.value as? [String: AnyObject] {
    let storedPlace = (dictionary["StoredPlaceName"] as? String?)!
    let lat = (dictionary["Latitude"] as? String?)!
    let long = (dictionary["Longitude"] as? String?)!
    let placeIcon = (dictionary["FolderIcon"] as? String?)!
    
        //this used to be as NSString
    let latitude = (lat! as NSString).doubleValue
                    
    let longitude = (long! as NSString).doubleValue
        
        
    let markers = GMSMarker()
                    markers.position = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
                    print(markers.position)
                        markers.icon = UIImage(named: placeIcon!)
        
                            //GMSMarker.markerImage(with: UIColor.purple)
        
                        markers.tracksViewChanges = true
        
                        //markers.title = storedPlace
                       // markers.snippet =
                       markers.map = self.vwGMap
       // self.placeNameinInfoView.text = storedPlace
        
        }
        }
        } )
        
        /*
        }
                }
                
            }
        
        }
            
        
   catch
   {
    //ERROR
        }
 */
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
    
    
    func fetchFolders() -> Array<Any> {
        
        var folders = [String]()
        let ref = FIRDatabase.database().reference().child((self.user?.uid)!).child("UserFolders")
        ref.observe( .childAdded, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                if let dictionary = snapshot.value
                    
                    as? [String: AnyObject] {
                    
                    
                    
                    let folder = (dictionary["FolderName"] as? String?)!
                    
                    folders.append(folder!)
                    DispatchQueue.main.async {
                        
                         self.Folders = folders
                        print(self.Folders)
                    }
                   
                
        
    }
                
            }
            
        }
            
        )
        return folders
        
    }
    
 

      func setupInIt() {
            
            var dropdownItems: NSMutableArray = NSMutableArray()
            
            for i in 0...(dataTitle.count-1) {
                
                var item = IGLDropDownItem()
                item.text = "\(dataTitle[i])"
                item.iconImage = dataImage[i]
                dropdownItems.add(addObject:item)
            }
    
            dropDownMenuFolder.menuText = "Choose Folder"
            dropDownMenuFolder.dropDownItems  = dropdownItems as! [AnyObject]
            dropDownMenuFolder.paddingLeft = 15
            dropDownMenuFolder.frame = CGRect(x: 40, y: 60, width: 200, height: 45)
            dropDownMenuFolder.delegate = self
            dropDownMenuFolder.type = IGLDropDownMenuType.stack
            dropDownMenuFolder.gutterY = 5
            dropDownMenuFolder.itemAnimationDelay = 0.1
            dropDownMenuFolder.reloadView()
            
            var myLabel = UILabel()
            myLabel.text = "SwiftyOS Blog"
            myLabel.textColor = UIColor.white
            myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
            myLabel.textAlignment = NSTextAlignment.center
          myLabel.frame = CGRect(x: 40, y: 60, width: 200, height: 45)
            
            self.mapCustomInfoWindow.addSubview(myLabel)
        mapCustomInfoWindow.addSubview(dropDownMenuFolder)
        
        
        }

        
        func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
            
            var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
            let folderItem = item.text
            self.folderItem = folderItem!
           let folderIconIndex = String(item.index)
           self.folderIconIndex = folderIconIndex
        }
    
    func animatedIn() {
        self.view.addSubview(addNewItem)
        addNewItem.center = self.view.center
        
        addNewItem.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addNewItem.alpha = 0
       
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView?.effect = self.effect
            self.visualEffectView?.isHidden = false
            self.addNewItem.alpha = 1
            self.addNewItem.transform = CGAffineTransform.identity
            
        }
    
    }
 
 
     
   //MARK: current location permission requests
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
            if (status == CLAuthorizationStatus.authorizedWhenInUse)
            
            {
                vwGMap.isMyLocationEnabled = true
            }
        }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let newLocation = locations.last
            vwGMap.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
            
            self.view = self.vwGMap
       /* let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.map = self.vwGMap
    */
        }
    
 //MARK: GMSMapview Delegate
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.vwGMap.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        self.vwGMap.isMyLocationEnabled = true
        if (gesture) {
            mapView.selectedMarker = nil
        }
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
       //marker.tracksViewChanges = true
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
        print(telephone)
        let openNowStatus = place.openNowStatus
        print(openNowStatus)
        let priceLevel = place.priceLevel
        print(priceLevel)
        let types = place.types
        print(types)
        let website = place.website
        print(website)
   
    }
    
 
    
    
        func viewController(_ viewcontroller: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
            print("ERROR AUTO COMPLETE \(error)")
        }
        
        func wasCancelled(_ viewController: GMSAutocompleteViewController) {
            self.dismiss(animated: true, completion: nil)
        }
    
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let searchWithAddress = GMSAutocompleteViewController()
        searchWithAddress.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "UK"
        self.locationManager.startUpdatingLocation()
        self.present(searchWithAddress, animated: true, completion: nil)
        
    }
    
    func save(){
        
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
    animatedIn()
        let location = marker.position
        print(location)
        addNewItem.center = mapView.projection.point(for: location)
        addNewItem.center.y -= 150
        
    return false
}
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
         let location = marker.position
      //  addNewItem.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
       // addNewItem.center.y -= 150
    }
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let location = marker.position
        print(location)
        mapCustomInfoWindow.center = mapView.projection.point(for: location)
        mapCustomInfoWindow.center.y -= 150
        self.view.addSubview(mapCustomInfoWindow)
        print("YOU PRESSED HERE")
    }
      //  let location = CLLocationCoordinate2D(latitude: (marker.userData as! location).lat, longitude: (marker.userData as! location).lon)
        
      
   /*    infoWindow.Name.text = (marker.userData as! location).name
        infoWindow.Price.text = (marker.userData as! location).price.description
        infoWindow.Zone.text = (marker.userData as! location).zone.rawValue
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
 */
      /*
        // Remember to return false
        // so marker event is still handled by delegate
 
        return false
    }
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("tapped")
        let newalert = UIAlertController(title: "would you like to remove this from wishlist?",
                                      message: newPlaceNameText,
                                      preferredStyle: .alert)
        let newcancelAction = UIAlertAction(title: "Remove",
                                         style: .default) { _ in
                                         
                                            self.marker.map = nil}
        
        newalert.addAction(newcancelAction)
self.present(newalert, animated: true, completion: nil)

    }
 */

    
 
    @IBOutlet weak var CancelAddNewPlace: UIButton!

   
    @IBAction func AddNewPlaceAction(_ sender: Any) {
        
        let PlaceName: String = self.newPlaceNameText
        print(PlaceName)
        let PlaceID = self.newPlacePlaceID
        let PlaceUnderFolder = self.folderItem
        let LongitudeCoordinate = self.longitudeText
        let LatitudeCoordinate = self.latitudeText
        let FolderIcon = self.folderIconIndex
        //this is not correct because it shows the whole array in one part
        let post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : LongitudeCoordinate as AnyObject, "Latitude" : LatitudeCoordinate as AnyObject]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
         marker.icon = UIImage(named: FolderIcon )
       mapCustomInfoWindow.removeFromSuperview()
       mapCustomInfoWindow.layer.borderWidth = 2
       mapCustomInfoWindow.layer.borderColor = UIColor.darkGray.cgColor
    }
    
   
    @IBAction func CancelAddNewPlace(_ sender: Any) {
        mapCustomInfoWindow.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
    }
    
    

}
