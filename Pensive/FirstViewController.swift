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
import GoogleMapsDirections
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import BTNavigationDropdownMenu

//var storedPlaces: [StoredPlace] = []
var storedPlaces: [NSManagedObject] = []
 
class FirstViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate, UIGestureRecognizerDelegate, UINavigationBarDelegate {

 
    @IBOutlet var addNewItemView: UIView!
   
    @IBOutlet var detailView: UIView!
    
    @IBOutlet weak var visualEffectsView: UIVisualEffectView!
    
   let items = ["Restaurants", "Museums", "Landmarks", "Favourites"]
    
   
   
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var vwGMap = GMSMapView()
    var Markers = [GMSMarker]()
    @IBAction func handleLongtap(sender: UILongPressGestureRecognizer) {
        print("PRESSED")
    }
   
    var place:GMSPlace?
    
    var marker = GMSMarker()
    
    var newPlaceName = ""
    var newPlaceAddress = ""
    var newPlacePlaceID = ""
    
    var telephone = ""
    var openNowStatus = ""
    var types = ""
    var priceLevel = ""
    var website = ""
    
    
    var latitudeText = ""
    var longitudeText = ""
    var newPlaceNameText = ""
    
  //var newPlaceLongitude =  0.0
  //  var newPlacelatitude = 0.0
    var user = FIRAuth.auth()?.currentUser
    var databaseRef = FIRDatabase.database().reference()




    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        let menuView = BTNavigationDropdownMenu(title: "Sort By", items: items as [AnyObject])
        self.navigationItem.titleView = menuView
        
        visualEffectsView.isHidden = true
        //visualEffectView?.effect = nil
        addNewItemView.layer.cornerRadius = 5
        
        
        
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
       
     // Google Maps Directions
        GoogleMapsDirections.provide(apiKey: "AIzaSyC-i5xPkUJ9yObNcwhGRjBYI8Q_wNsWZr4")
        let origin = GoogleMapsDirections.Place.placeID(id: "ChIJxc4vk9QEdkgRjJ2al7_P9uw")
        let destination = GoogleMapsDirections.Place.placeID(id: "ChIJb9sw59k0K4gRZZlYrnOomfc")
        
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                debugPrint(response?.errorMessage)
                return
            }
        //        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
         //       self.vwGMap.addGestureRecognizer(longPressRecognizer)
            
        }
       //let mapView = GMSMapView.map(withFrame:  .zero, camera: camera)
       // mapView.settings.myLocationButton = true
       // mapView.delegate = self
    
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
                 let latitude = (lat as NSString).doubleValue
                    
                   
                    
                      let longitude = (long as NSString).doubleValue
                      
                    
                
                       
                
                        let markers = GMSMarker()
                    markers.position = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
                    print(markers.position)
                        markers.icon = GMSMarker.markerImage(with: UIColor.purple)
                        markers.tracksViewChanges = true
                        markers.title = name
                        markers.snippet = address
                       markers.map = vwGMap
                    }
                }
                
            }
        
            }
            
        
   catch
   {
    //ERROR
        }

    }
 
    func animatedIn() {
        self.view.addSubview(addNewItemView)
        addNewItemView.center = self.view.center
        
        addNewItemView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addNewItemView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            //self.visualEffectView?.effect = self.effect
            self.visualEffectsView?.isHidden = false
            self.addNewItemView.alpha = 1
            self.addNewItemView.transform = CGAffineTransform.identity
            
        }
        
    }
    @IBAction func addButton(_ sender: Any) {
        animatedIn()
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
        //print("Place name: ", place.name)
        //print("Place address: ", place.formattedAddress)
        //print("Place placeID: ", place.placeID)
        //print("Place attributions: ", place.attributions)
        //print("Place Coordinate:", place.coordinate)
        //The printing only happens in the terminal
        
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
        // let entity = NSEntityDescription.entity(forEntityName: "StoredPlace",
        //                          in: context)!
        
        // let newPlace = NSManagedObject(entity: entity,
        //       insertInto: context)
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
    
        let alert = UIAlertController(title: "Add this place to wishlist?",
                                      message: newPlaceNameText,
                                      preferredStyle: .alert)
  
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
       self.save()
         marker.icon = GMSMarker.markerImage(with: UIColor.purple)
            let Pname: String = self.newPlaceNameText
            print(Pname)
            let PplaceID = self.newPlacePlaceID
            //this is not correct because it shows the whole array in one part
            let post : [String: AnyObject] = ["storedName" : Pname as AnyObject, "placeID" : PplaceID as AnyObject]
            
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("PlaceNames").child((self.user?.uid)!).childByAutoId().setValue(post)
        }
                       let cancelAction = UIAlertAction(title: "Remove",
                                         style: .default) { _ in marker.map = nil}
      
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
       
        self.present(alert, animated: true, completion: nil)


      //  let location = CLLocationCoordinate2D(latitude: (marker.userData as! location).lat, longitude: (marker.userData as! location).lon)
        
      
   /*     infoWindow.Name.text = (marker.userData as! location).name
        infoWindow.Price.text = (marker.userData as! location).price.description
        infoWindow.Zone.text = (marker.userData as! location).zone.rawValue
        infoWindow.center = mapView.projection.point(for: location)
        infoWindow.button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
 */
        
        // Remember to return false
        // so marker event is still handled by delegate
 
        return false
    }
    
    // let the custom infowindow follows the camera
  //  func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
  //      if (tappedMarker.userData != nil){

  //        let location = CLLocationCoordinate2D(latitude: (tappedMarker.userData as! location).lat, longitude: (tappedMarker.userData as! location).lon)
 
  //          infoWindow.center = mapView.projection.point(for: location)
   //     }
 //   }
   /* func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
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
}



