//
//  RecommendationsViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 17/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces

class RecommendationsViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var addRecommendationButton: UIButton!
    
    var dictionary = [String: AnyObject]()
    var cattchefolderexists = false
    
    let placesClient = GMSPlacesClient.shared()
    var place:GMSPlace?
    
    var PlaceName = ""
    var PlaceAddress = ""
    var PlaceTelephone = ""
    var PlaceWebsite = ""
    var PlaceID = ""
    var PlaceUnderFolder = "Cattche Recommendations"
    var FolderIcon = "4"
    
    var latitudeText = ""
    var longitudeText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.frame = CGRect(x: 150, y: 300, width: 100, height: 100)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubview(toFront: view)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicator.startAnimating()
        let recommendationsURL = NSURL(string: "https://www.cattche.com/instagram")
        let request = NSURLRequest(url: recommendationsURL! as URL)
        webView.loadRequest(request as URLRequest);
       
        let ref = Database.database().reference().child("AddRecommendation")
        
        ref.observe( .value, with: { (snapshot) in
        self.dictionary = (snapshot.value as? [String: AnyObject])!
          //  print(self.dictionary)
          self.PlaceID = (self.dictionary["StoredPlaceID"] as? String!)!
       print(self.PlaceID)
            self.lookUpPlaceID()
            }
    )
webView.isUserInteractionEnabled = false
        for p in STOREDFolders {
            let item = p["FolderName"] as? String
            print(item)
            if item == "Cattche Recommendations"  {
            self.cattchefolderexists = true
                print(self.cattchefolderexists)
            } else {
                print("WE HAVE NO CATTCHE")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lookUpPlaceID() {
        print("THIS IS FROM LOOKUP ID")
        //print(PlaceID)
        self.placesClient.lookUpPlaceID(self.PlaceID, callback: { (placeID, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            
            guard let place = self.place else {
                print("No place details for \(placeID)")
                
           //     self.LatitudeCoordinate = (placeID?.coordinate.latitude as? String)!
                
    let newPlaceLongitude = (placeID?.coordinate.longitude)!
    var longitudeText:String = "\(newPlaceLongitude)"
    self.longitudeText = "\(newPlaceLongitude)"
                
    let newPlaceLatitude = (placeID?.coordinate.latitude)!
    var latitudeText:String = "\(newPlaceLatitude)"
    self.latitudeText = "\(newPlaceLatitude)"
              
            
    self.PlaceName = (placeID?.name)!
    self.PlaceAddress = (placeID?.formattedAddress)!
                
    var telephone = placeID?.phoneNumber
                if telephone == nil {
                    self.PlaceTelephone = ""
                } else {
                    self.PlaceTelephone = telephone!
                }
                
    var website =  placeID?.website
                //this doesnt really save the website
                if website == nil {
                    self.PlaceWebsite = ""
                    print("THERE IS NO WEBSITE")
                } else {
                    var newWebsite = website!
                    self.PlaceWebsite = "\(newWebsite)"
                    print("THERE IS A WEBSITE")
                }
            //    self.PlaceWebsite = (placeID?.website as? String)!
             //   self.PlaceTelephone = (placeID?.phoneNumber)!
              
                return
            }
            /*
            print("Place name \(place.name)")
            print("Place address \(place.formattedAddress)")
            print("Place placeID \(place.placeID)")
            print("Place attributions \(place.attributions)")
 */
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   
    @IBAction func addRecommendationAction(_ sender: Any) {
    var user = Auth.auth().currentUser
        
    let databaseRef = Database.database().reference()
    
    var post : [String: AnyObject] = ["StoredPlaceName" : PlaceName as AnyObject, "StoredPlaceID" : PlaceID as AnyObject, "StoredPlaceAddress" : PlaceAddress as AnyObject, "StoredPlaceWebsite" : PlaceWebsite as AnyObject, "StoredPlaceTelephone" : PlaceTelephone as AnyObject,  "PlaceUnderFolder" : PlaceUnderFolder as AnyObject,"FolderIcon" : FolderIcon as AnyObject,  "Longitude" : longitudeText as AnyObject, "Latitude" : latitudeText as AnyObject, "Rating" : 0 as AnyObject, "Tags" : "" as AnyObject, "Checkbox" : false as AnyObject, "StoredPlacePicture": "" as AnyObject ]
        databaseRef.child((user?.uid)!).child("StoredPlaces").childByAutoId().setValue(post)
      
        for p in STOREDFolders {
            let item = p["FolderName"] as? String
            print(item)
            if item == "Cattche Recommendations"  {
                self.cattchefolderexists = true
                print(self.cattchefolderexists)
            } else {
                print("WE HAVE NO CATTCHE")
                self.cattchefolderexists = false
            }
        }
        if cattchefolderexists == false {
          let post : [String: AnyObject] = ["FolderName" : "Cattche Recommendations" as AnyObject, "FolderIcon" : "4" as AnyObject ]
    databaseRef.child((user?.uid)!).child("UserFolders").childByAutoId().setValue(post)
            print("We are creating a cattche folder")
        } else {
            print("We already have a cattche folder")
        }
}
    
   
}
