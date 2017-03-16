//
//  ProfilePageViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 28/02/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

class ProfilePageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate {

    @IBOutlet weak var profilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Making the profile picture a circle
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.orange.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
      
        emailTextField.text = "Hello"
    }

    //Allows you the action to upload profile picture 
  
   
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
    
    //@IBAction func selectImageFromPhotoLibrary(_ sender: AnyObject) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profilePhoto.image = selectedImage
        dismiss(animated: true, completion: nil)
      
    }

    //MARK: filling in the textfields
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func usernameTextFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func emailTextFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func passwordTextFieldAction(_ sender: Any) {
    }
    
    @IBOutlet weak var dobTextField: UITextField!
    
    @IBAction func dobTextFieldAction(_ sender: Any) {
    }
    //MARK: Sex selection
    
    
    @IBOutlet weak var sexPickerTextFeild: UITextField!
    @IBOutlet weak var sexPicker: UIPickerView!
    
    var gender = ["Male","Female"]
    
    //drop down sex selection picker 
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return gender.count
        
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        self.sexPickerTextFeild.text = self.gender[row]
        self.sexPicker.isHidden = true
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        return gender[row]
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.sexPickerTextFeild {
            self.sexPicker.isHidden = false
            //if you dont want the users to se the keyboard type:
            
            textField.endEditing(true)
        }
        
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
