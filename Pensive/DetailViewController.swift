//
//  DetailViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 12/12/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import CoreData
import BEMCheckBox
import Firebase

protocol DataEnteredDelegate: class {
    func userDidEnterInformation(info: String)
    func userDidChangePhoto(info2: UIImage)
    func userDidChangeRating(info3: Int)
    func userDidChangeCheckbox(info4: Bool)
}

// var selectedPlaceDetail = [String:AnyObject]()
class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BEMCheckBoxDelegate {
      weak var delegate: DataEnteredDelegate? = nil
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var placeName: UILabel!
  
    @IBOutlet var placeAddress: UILabel!

    @IBOutlet var placeWebsite: UITextView!
   
    @IBOutlet var placeTelephone: UITextView!
    
    @IBOutlet var addNotes: UITextField!
     
    @IBOutlet var addPicture: UIImageView!
    
    @IBOutlet var checkBox: BEMCheckBox!
  
    
    @IBOutlet var ratingControl: RatingControl!
    
   var jpg = NSData()
    
   // var selectedPlaceDetail = [String:AnyObject]()
    let user = Auth.auth().currentUser
    var firebaseKey = ""
    var placeNotes = ""
    override func viewDidLoad() {
       
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
       
        placeName.text = selectedPlace["StoredPlaceName"] as! String?
        placeAddress.text = selectedPlace["StoredPlaceAddress"] as! String?
       
        placeTelephone.text = selectedPlace["StoredPlaceTelephone"] as! String?
        self.view.addSubview(placeWebsite)
        print(placeTelephone.text)
        placeWebsite.text = selectedPlace["StoredPlaceWebsite"] as! String?
        print(placeWebsite.text)
       ratingControl.firebaseKey = (selectedPlace["firebaseKey"] as! String?)!
     ratingControl.rating = selectedPlace["Rating"] as! Int
       addNotes.text = selectedPlace["Tags"] as! String?
        checkBox.offAnimationType = BEMAnimationType.flat
        checkBox.onAnimationType = BEMAnimationType.oneStroke
        checkBox.tintColor = UIColor.lightGray
        checkBox.onCheckColor = UIColor.red
        checkBox.onTintColor = UIColor.orange
        var onCheckbox = selectedPlace["Checkbox"] as! Bool
        self.checkBox.setOn(onCheckbox, animated: true)
       
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        addPicture.layer.borderWidth = 1
        addPicture.layer.masksToBounds = false
        addPicture.layer.borderColor = UIColor.orange.cgColor
    
        //addPicture.layer.cornerRadius = addPicture.frame.height/2
        addPicture.clipsToBounds = true
        addPicture.isUserInteractionEnabled = true
        addPicture.layer.cornerRadius = 10
        /*
        let userID: String = (Auth.auth().currentUser?.uid)!
        let databaseRef = Database.database().reference()
        let storageRef = Storage.storage().reference().child(userID).child(firebaseKey).child("StoredPlacePicture")
        
        databaseRef.child(userID).child("StoredPlaces").child(firebaseKey).observe(.value, with: { (snapshot) in
      //   let userID: String = (Auth.auth().currentUser?.uid)!
     //    let storageRef = Storage.storage().reference().child(userID).child(self.firebaseKey).child("StoredPlacePicture")
         storageRef.getData(maxSize: 10*1024*1024, completion: {(data, error) -> Void in
         if (error != nil) {
         print("got no pic")
         } else {
         
         let addPlacePicture = UIImage(data: data!)
         self.addPicture.image = addPlacePicture
         print("I HAVE YOUR PHOTO")
         }
         }
            )} )
 */
/*
            storageRef.getData(maxSize: 10*1024*1024, completion: {(data, error) -> Void in
                if (error != nil) {
                    print("got no pic")
                } else {
                    
                    let addPlacePicture = UIImage(data: data!)
                    self.addPicture.image = addPlacePicture
                    print("I HAVE YOUR PHOTO")
                }
            }
            )}
        )
*/
     //   let b = STOREDPlaces.contains { (key, value) -> Bool in
      //      value as? String == "London"
      //  }
        
    
       // let drinks = STOREDPlaces.map({$0["StoredPlaceName"]})
       // print(drinks)
    //    var drinksArray = [AnyObject]()
   //  drinksArray.append(drinks as AnyObject)
        
   //  print(ratingControl.rating)
        
        //Retreiving data from Firebase for text-field- Username
        let ref = Database.database().reference().child((user?.uid)!).child("StoredPlaces")
        
        ref.observe(.childChanged, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                /*
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        self.firebaseKey = key
                        var PLACE = (dictionary as? [String: AnyObject]!)!
                       var this  = (PLACE?["Tags"] as? String)!
                        
                        PLACE?.updateValue(self.firebaseKey as AnyObject, forKey: "firebaseKey")
                        
                    }
                }
            }
        }
        )
     
    }
*/
                
                let userID: String = (Auth.auth().currentUser?.uid)!
                let storageRef = Storage.storage().reference().child(userID).child(self.firebaseKey).child("StoredPlacePicture")
                storageRef.getData(maxSize: 10*1024*1024, completion: {(data, error) -> Void in
                    if (error != nil) {
                        print("got no pic")
                        print(data)
                    } else {
                        
                        let addPlacePicture = UIImage(data: data!)
                        self.addPicture.image = addPlacePicture
                        print("I HAVE YOUR PHOTO")
                    }
                }
                    )
        
            

                ref.observe( .value, with: { (snapshot) in
                    STOREDPlaces.removeAll()
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        for snap in snapshots {
                            if let dictionary = snapshot.value as? [String: AnyObject] {
                                let key = snap.key
                                self.firebaseKey = key
                                var PLACE = (dictionary[key] as? [String: AnyObject]!)!
                                PLACE?.updateValue(self.firebaseKey as AnyObject, forKey: "firebaseKey")
                                print(PLACE)
                                STOREDPlaces.append(PLACE!)
                            }
                        }
                    }
                })
            }
        })
        
            // obj is a string array. Do something with stringArray
            if let checkedUrl = URL(string: selectedPlace["StoredPlacePicture"] as! String) {
                
                print(selectedPlace["StoredPlacePicture"] as! String)
                //addPicture.contentMode = .scaleAspectFit
                downloadImage(url: checkedUrl)
                print("data image not nil")
        }
        
           checkBox.delegate = self
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        print(checkBox.on)
        let checkboxstate = checkBox.on
                delegate?.userDidChangeCheckbox(info4: checkboxstate)
                print("this is printing the selected place checkbox")
                    let firebaseKey = selectedPlace["firebaseKey"] as! String?
        if firebaseKey == "" {
            print("firebase key is nil")
        } else {
                    let databaseRef = Database.database().reference()
                    databaseRef.child((self.user?.uid)!).child("StoredPlaces").child(firebaseKey!).updateChildValues(["Checkbox" : checkboxstate])
        }
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
 
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
               self.addPicture.image = UIImage(data: data)
            }
        }
    }
    
  
        

    
    //Setting up the animation
    
  
    @IBAction func closeButtonAction(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
        
        /*
        let controller = segue.destination as! TableMapViewController
        print("IS THIS WOEKING")
        print(placeNotes)
        controller.selectedPlace["Tags"] = "THIS IS CHANGING" as AnyObject
 */
   //     selectedPlace.updateValue("HELLO" as AnyObject, forKey: "Tags")
        let rating = ratingControl.rating
        print(rating)
        delegate?.userDidChangeRating(info3: rating)
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        print(addNotes.text)
       //selectedPlaceDetail.updateValue(addNotes.text as AnyObject, forKey: "Tags")
      //  self.addNotes.text = blob as! String
      // print(selectedPlaceDetail)
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    @IBAction func editingTextField(_ sender: Any) {
        //  selectedPlaceDetail.updateValue(addNotes.text as AnyObject, forKey: "Tags")
       self.placeNotes = addNotes.text!
       // selectedPlace.updateValue(addNotes.text as AnyObject, forKey: "Tags")
       // print(addNotes.text)
       // print(selectedPlaceDetail)\
    delegate?.userDidEnterInformation(info: addNotes.text!)
    }
    @IBAction func pickPhotoFromLibrary(_ sender: UITapGestureRecognizer) {
        print("I am being tapped")
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        addPicture.image = selectedImage
        dismiss(animated: true, completion: nil)
        
        let userID: String = (Auth.auth().currentUser?.uid)!
        let firebaseKey = (selectedPlace["firebaseKey"] as! String?)
        if firebaseKey == "" {
            print("firebase key is nil")
        } else {
        let storageRef = Storage.storage().reference().child(userID).child(firebaseKey!).child("StoredPlacePicture")
        var uploadData = NSData()
        uploadData = UIImagePNGRepresentation(addPicture.image!)! as NSData
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        storageRef.putData(uploadData as Data , metadata: uploadMetadata) { (metadata, error) in
            if (error != nil) {
                print("I received an error")
            } else {
                print("Upload conplete!")
                if let downloadURL = metadata!.downloadURL()?.absoluteString {
                    
                    var user = Auth.auth().currentUser
                    var databaseRef = Database.database().reference()
                    
                    let userDataProfilePicURL : [String: AnyObject] = ["StoredPlacePicture" : downloadURL as AnyObject]
                  
                    databaseRef.child((user?.uid)!).child("StoredPlaces").child(firebaseKey!).updateChildValues(userDataProfilePicURL)
                }
            }
            
        }
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    @IBAction func addNotesAction(_ sender: Any) {
        
        let Notes = addNotes.text
       let firebaseKey = selectedPlace["firebaseKey"] as! String?
        
        //this is not correct because it shows the whole array in one part
        if firebaseKey == "" {
            print("firebase key is nil")
        } else {
        let databaseRef = Database.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").child(firebaseKey!).updateChildValues(["Tags" : Notes])
        }
    }
    
}
extension UIImage {
    var jpeg: Data? {
        return UIImageJPEGRepresentation(self, 1)   // QUALITY min = 0 / max = 1
    }
}
