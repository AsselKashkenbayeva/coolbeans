//
//  DetailViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 12/12/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//MARK: Properties
    
  
    @IBOutlet weak var placeAddressLabel: UILabel!
   
    
    @IBOutlet weak var placeNameLabel: UILabel!
  
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var storedID = ""
    var detailPlace: NSManagedObject!
    var storedNames = [String]()
    var storedName = ""
    var storedAddresses = [String]()
    var storedAddress = ""

   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = detailPlace.value(forKey: "name") as? String {
                   placeNameLabel.text = name
            
                     
                        print()
                        //print(name)
                    }
                    if let address = detailPlace.value(forKey: "address") as? String
                    {
                       placeAddressLabel.text = address
                        //Print(address)
                    }
                  
                    
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
