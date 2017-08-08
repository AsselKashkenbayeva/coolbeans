//
//  LoginViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 21/11/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
   
    let loginToList = "LoginToList"
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    @IBOutlet weak var LogoutButton: UIButton!
    @IBOutlet weak var EnterButton: UIButton!
    var textValue: String = ""
    override func viewDidLoad() {
    super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        if let user = Auth.auth().currentUser
        {
            self.LogoutButton.alpha = 1.0
            self.EnterButton.alpha = 1.0
        }
        else
        {
            self.LogoutButton.alpha = 0.0
            self.EnterButton.alpha = 0.0
        }
      textFieldLoginEmail.text = textValue
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapSignUp(_ sender: AnyObject) {
        if self.textFieldLoginEmail.text == "" && self.textFieldLoginPassword.text == ""
        {
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
           
    }
        else {
            Auth.auth().createUser(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, completion: { (user, error) in
                if error == nil
                {
                    var user = Auth.auth().currentUser
                    var databaseRef = Database.database().reference()
                    let userEmail = self.textFieldLoginEmail.text
                   // let userPassword = self.textFieldLoginPassword.text
                    let userDataEmail : [String: AnyObject] = ["Email" : userEmail as AnyObject]
                 //   let userDataPassword :[String: AnyObject] = ["Password" : userPassword as AnyObject]
                    databaseRef.child((user?.uid)!).child("Email").setValue(userDataEmail)
                  //databaseRef.child((user?.uid)!).child("Password").setValue(userDataPassword)
                 
                    self.LogoutButton.alpha = 1.0
                    self.EnterButton.alpha = 1.0
                    self.textFieldLoginEmail.text = ""
                    self.textFieldLoginPassword.text = ""
                     self.performSegue(withIdentifier: self.loginToList, sender: nil)
                    
                    let profilePageViewController:
                        ProfilePageViewController = self.storyboard!.instantiateViewController(withIdentifier: "ProfilePageViewController") as! ProfilePageViewController
                 profilePageViewController.passwordTextField.text = self.textFieldLoginPassword.text
 
                    
        }
                else
                {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            } )
    }
    }
    
    @IBAction func didTapSignIn(_ sender: AnyObject) {
        if self.textFieldLoginEmail.text == "" && self.textFieldLoginPassword.text == ""
        {
            let alertController = UIAlertController(title: "Oops", message: "Please enter an email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
         
            Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, completion: { (user, error) in
                if error == nil
                {
                
                    var user = Auth.auth().currentUser
                    var databaseRef = Database.database().reference()
                    let userEmail = self.textFieldLoginEmail.text
                 //   let userPassword = self.textFieldLoginPassword.text
                    let userDataEmail : [String: AnyObject] = ["Email" : userEmail as AnyObject]
                   // let userDataPassword :[String: AnyObject] = ["Password" : userPassword as AnyObject]
                    databaseRef.child((user?.uid)!).child("Email").setValue(userDataEmail)
                //databaseRef.child((user?.uid)!).child("Password").setValue(userDataPassword)
                
                    self.LogoutButton.alpha = 1.0
                    self.EnterButton.alpha = 1.0
                    self.textFieldLoginEmail.text = ""
                    self.textFieldLoginPassword.text = ""
                    self.performSegue(withIdentifier: self.loginToList, sender: nil)
                
                    //putting the current user email and password into Firebase database
              
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }

            })
            }
    }
   
    @IBAction func LogoutAction(_ sender: AnyObject) {
        try! Auth.auth().signOut()
        self.LogoutButton.alpha = 0.0
        self.EnterButton.alpha = 0.0
        self.textFieldLoginEmail.text = ""
        self.textFieldLoginPassword.text = ""
    }

    
    @IBAction func EnterButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
    }
 
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
}
