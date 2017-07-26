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

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
var user = Auth.auth().currentUser
    @IBOutlet weak var placeAddressLabel: UILabel!
   
    @IBOutlet var checkBox: BEMCheckBox!
    
    @IBOutlet weak var placeNameLabel: UILabel!
  
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var storedID = ""
    var detailPlace: NSManagedObject!
    var storedNames = [String]()
    var storedName = ""
    var storedAddresses = [String]()
    var storedAddress = ""
    var onCheckbox: Bool = false
   

    override func viewDidLoad() {
        super.viewDidLoad()
        checkBox.offAnimationType = BEMAnimationType.flat
        checkBox.onAnimationType = BEMAnimationType.oneStroke
       // onCheckbox = (STOREDPlaces[itemIndex]["VisitedCheckbox"] as? Bool)!
   self.checkBox.setOn(onCheckbox, animated: true)
        
        placeNameLabel.text = STOREDPlaces[itemIndex]["StoredPlaceName"] as? String
        placeAddressLabel.text = STOREDPlaces[itemIndex]["StoredPlaceAddress"] as? String
        
       // checkBox.delegate = self.checkBox as! BEMCheckBoxDelegate?
        print(checkBox.delegate?.didTap!(checkBox))
        let databaseRef = Database.database().reference()
        databaseRef.child((self.user?.uid)!).child("StoredPlaces").didChangeValue(forKey: "VisitedCheckbox")
      
        
        
                }
                
    
            


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: AnyObject) {
        
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
        
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
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
