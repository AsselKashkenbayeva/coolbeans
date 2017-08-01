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
import BubbleTransition
 var selectedPlace = [String:AnyObject]()
class TableMapViewController: UIViewController,GMSMapViewDelegate, UIViewControllerTransitioningDelegate, DataEnteredDelegate {
    
    let transition = BubbleTransition()
    
let gradientLayer = CAGradientLayer()
    @IBOutlet var mapView: GMSMapView!
   // var selectedPlace = [String:AnyObject]()
    
    @IBOutlet var somebutton: UIButton!
    @IBOutlet var detailView: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var addressLabel: UILabel!
    
    @IBOutlet var telephoneLabel: UITextView!
    @IBOutlet var websiteLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        somebutton.layer.borderWidth = 2
        somebutton.layer.masksToBounds = false
        somebutton.layer.borderColor = UIColor.orange.cgColor
        somebutton.layer.cornerRadius = somebutton.frame.height/2
      somebutton.clipsToBounds = true
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.backgroundColor = UIColor.clear
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor.clear.cgColor
        let color2 = UIColor.white.cgColor
        let color3 = UIColor.lightGray.cgColor
        gradientLayer.colors = [color1,color2]
        gradientLayer.locations = [0.6,0.7]
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
        
    self.view.addSubview(detailView)
        detailView.addSubview(somebutton)
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
    func userDidEnterInformation(info: String) {
        print(info)
      selectedPlace.updateValue(info as AnyObject, forKey: "Tags")
    }
    func userDidChangePhoto(info2: UIImage) {
        selectedPlace.updateValue(info2, forKey: "StoredPlacePicture")
        print(selectedPlace["StoredPlacePicture"])
    }
    func userDidChangeRating(info3: Int) {
        selectedPlace.updateValue(info3 as AnyObject, forKey: "Rating")
    }
    func userDidChangeCheckbox(info4: Bool) {
        selectedPlace.updateValue(info4 as AnyObject, forKey: "Checkbox")
    }
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! DetailViewController
        controller.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        controller.modalPresentationStyle = .custom
        controller.delegate = self
        //controller.selectedPlaceDetail = selectedPlace
        //selectedPlaceDetail = selectedPlace
    //    selectedPlace = selectedPlaceDetail
        //selectedPlace.updateValue("test1" as AnyObject, forKey: "Tags")
        print("THIS IS SELECTED PLACE")
        print(selectedPlace)
        print("THIS IS SELECTED PLACE DETAIL")
    //    print(selectedPlaceDetail)
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = somebutton.center
        transition.bubbleColor = somebutton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = somebutton.center
        transition.bubbleColor = somebutton.backgroundColor!
        return transition
    }
    

}
