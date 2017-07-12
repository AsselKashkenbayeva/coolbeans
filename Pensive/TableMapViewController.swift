//
//  TableMapViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 05/07/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class TableMapViewController: UIViewController,GMSMapViewDelegate {
let gradientLayer = CAGradientLayer()
    @IBOutlet var mapView: GMSMapView!
    var selectedPlace = [String:AnyObject]()
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var telephoneLabel: UITextView!
    @IBOutlet var websiteLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.backgroundColor = UIColor.clear
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.clear.cgColor
        let color2 = UIColor.lightGray.cgColor
        let color3 = UIColor.white.cgColor
        gradientLayer.colors = [color1,color3]
        gradientLayer.locations = [0.6,0.8]
        self.view.layer.addSublayer(gradientLayer)

        mapView.delegate = self
        let lat = (selectedPlace["Latitude"] as? NSString)?.doubleValue
        let long = (selectedPlace["Longitude"] as? NSString)?.doubleValue
      
        //This is setting the default view on London
       mapView.camera = GMSCameraPosition.camera(withLatitude: lat as! CLLocationDegrees!, longitude: long as! CLLocationDegrees! , zoom: 10.0)
        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true
        mapView.settings.compassButton = true
        mapView.settings.allowScrollGesturesDuringRotateOrZoom = true
        
        let placeMarker = GMSMarker()
        placeMarker.position = CLLocationCoordinate2D(latitude: lat! , longitude: long!)
        
        placeMarker.icon = UIImage(named:selectedPlace["FolderIcon"]! as! String)
         placeMarker.map = self.mapView
        
        nameLabel.text = selectedPlace["StoredPlaceName"] as! String?
        addressLabel.text = selectedPlace["StoredPlaceAddress"] as! String?
        telephoneLabel.text = selectedPlace["StoredPlaceTelephone"] as! String?
        websiteLabel.text = selectedPlace["StoredPlaceWebsite"] as! String?
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
