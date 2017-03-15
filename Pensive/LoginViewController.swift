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
   
    override func viewDidLoad() {
    super.viewDidLoad()
      //  let ref = FIRDatabase.database().reference(fromURL: "https://pensive-147417.firebaseio.com/")
       // ref.updateChildValues(<#T##values: [AnyHashable : Any]##[AnyHashable : Any]#>)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        if let user = FIRAuth.auth()?.currentUser
        {
            self.LogoutButton.alpha = 1.0
            self.EnterButton.alpha = 1.0
            
        }
        else
        {
            self.LogoutButton.alpha = 0.0
            self.EnterButton.alpha = 0.0
        }
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
        else{
            
            FIRAuth.auth()?.createUser(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, completion: { (user, error) in
                if error == nil
                {
                    self.LogoutButton.alpha = 1.0
                    self.EnterButton.alpha = 1.0
                    self.textFieldLoginEmail.text = ""
                    self.textFieldLoginPassword.text = ""
                     self.performSegue(withIdentifier: self.loginToList, sender: nil)
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
            FIRAuth.auth()?.signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!, completion: { (user, error) in
                if error == nil
                {
                    self.LogoutButton.alpha = 1.0
                    self.EnterButton.alpha = 1.0
                    self.textFieldLoginEmail.text = ""
                    self.textFieldLoginPassword.text = ""
                    self.performSegue(withIdentifier: self.loginToList, sender: nil)
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
    
    //after successfully authenticating users, we want to persist data 

   
    @IBAction func LogoutAction(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
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
