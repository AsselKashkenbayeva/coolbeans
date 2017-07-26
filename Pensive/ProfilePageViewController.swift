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
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var sexPickerTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
//FIRDatabase.database().persistenceEnabled = true
        //Making the profile picture a circle
        profilePhoto.layer.borderWidth = 1
        profilePhoto.layer.masksToBounds = false
        profilePhoto.layer.borderColor = UIColor.orange.cgColor
        profilePhoto.layer.cornerRadius = profilePhoto.frame.height/2
        profilePhoto.clipsToBounds = true
      
       //Retreiving data from Firebase for text-field- Username
        let ref = Database.database().reference()
        let userID: String = (Auth.auth().currentUser?.uid)!
        ref.child(userID).child("Username").observe(.value, with: { (snapshot) in
           let username = (snapshot.value as? NSDictionary)?["Username"] as? String ?? ""
            self.usernameTextField.text = username
            //.child("Username")
        })
        //Retreiving data from Firebase for text-field- Email
        ref.child(userID).child("Email").observe(.value, with: { (snapshot) in
            let email = (snapshot.value as? NSDictionary)?["Email"] as? String ?? ""
            self.emailTextField.text = email
            //.child("Email")
        })
        //Retreiving data from Firebase for text-field- Password
        ref.child(userID).child("Password").observe(.value, with: { (snapshot) in
            let password = (snapshot.value as? NSDictionary)?["Password"] as? String ?? ""
            self.passwordTextField.text = password
            //.child("Password")
        })
        //Retreiving data from Firebase for text-field- DOB
        ref.child(userID).child("DOB").observe(.value, with: { (snapshot) in
            let dob = (snapshot.value as? NSDictionary)?["DOB"] as? String ?? ""
            self.dobTextField.text = dob
            //.child("DOB")
        })
        
        //Retreiving data from Firebase for text-field- Gender
        ref.child(userID).child("Gender").observe(.value, with: { (snapshot) in
            let gender = (snapshot.value as? NSDictionary)?["Gender"] as? String ?? ""
            self.sexPickerTextFeild.text = gender
            //.child("Gender")
        })
        
       //hide pickerview until textfield selected
      sexPicker.isHidden = true
        
        //retreive profile photo from Firebase 
        let storageRef = Storage.storage().reference().child(userID).child("ProfilePic")
      ref.child(userID).child("ProfilePic").observe(.value, with: { (snapshot) in
        storageRef.getData(maxSize: 10*1024*1024, completion: {(data, error) -> Void in
                    if (error != nil) {
                        print("got no pic")
                    } else {
                    
                    let profilePhoto = UIImage(data: data!)
                    self.profilePhoto.image = profilePhoto
                        print("I HAVE YOUR PHOTO")
                    }
        }
        )}
        )}


    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    //Allows you the action to upload profile picture
  
   
    @IBAction func selectImageFromPhotoLibrary(_ sender: Any) {
    
        
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
      let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        profilePhoto.image = selectedImage
         dismiss(animated: true, completion: nil)
        let userID: String = (Auth.auth().currentUser?.uid)!
        let storageRef = Storage.storage().reference().child(userID).child("ProfilePic")
        var uploadData = NSData()
        uploadData = UIImagePNGRepresentation(profilePhoto.image!)! as NSData
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

                    let userDataProfilePicURL : [String: AnyObject] = ["ProfilePicURL" : downloadURL as AnyObject]
                    databaseRef.child((user?.uid)!).child("ProfilePicURL").setValue(userDataProfilePicURL)
                }
            }
            
        }
      
            }
 

    //MARK: filling in the textfields
    
    
    @IBAction func usernameTextFieldAction(_ sender: Any) {
        
        var user = Auth.auth().currentUser
        var databaseRef = Database.database().reference()
        let userUsername = self.usernameTextField.text
        let userData : [String: AnyObject] = ["Username" : userUsername as AnyObject]
            databaseRef.child((user?.uid)!).child("Username").setValue(userData)
        //.child("Username")
    }
    
   
    
    @IBAction func emailTextFieldAction(_ sender: Any) {
    }
    
    
    
    @IBAction func passwordTextFieldAction(_ sender: Any) {
        var user = Auth.auth().currentUser
        var databaseRef = Database.database().reference()
        let password = self.passwordTextField.text
        let userDataPassword : [String: AnyObject] = ["Password" : password as AnyObject]
        databaseRef.child((user?.uid)!).child("Password").setValue(userDataPassword)
      //.child("Password")
    }
    
    
    @IBAction func dobTextFieldAction(_ sender: Any) {
        var user = Auth.auth().currentUser
        var databaseRef = Database.database().reference()
        let dob = self.dobTextField.text
        let userDataDOB : [String: AnyObject] = ["DOB" : dob as AnyObject]
        databaseRef.child((user?.uid)!).child("DOB").setValue(userDataDOB)
        //.child("DOB")
    }
    //MARK: Sex selection
    
    
   
    @IBOutlet weak var sexPicker: UIPickerView!
    
    var gender = ["Male","Female","Prefer not to say", "Other"]
    
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
        
        var user = Auth.auth().currentUser
        var databaseRef = Database.database().reference()
        let gender = self.sexPickerTextFeild.text
        let userDataGender : [String: AnyObject] = ["Gender" : gender as AnyObject]
    databaseRef.child((user?.uid)!).child("Gender").setValue(userDataGender)
        //.child("Gender")
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
