//
//  ForgottenPasswordViewController.swift
//  
//
//  Created by Assel Kashkenbayeva on 23/11/2016.
//
//

import UIKit
import Firebase

class ForgottenPasswordViewController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
}

    @IBAction func submitAction(_ sender: AnyObject) {
        if self.EmailField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            
             self .present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.EmailField.text!, completion: { (error) in
                var title = ""
                var message = ""
                
                if error != nil
                {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                }
                else
                {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.EmailField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self .present(alertController, animated: true, completion: nil)
            })
        }
        }
    
}
