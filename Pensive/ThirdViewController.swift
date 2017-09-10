//
//  ThirdViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 25/10/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import BubbleTransition

class ThirdViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    let transition = BubbleTransition()
    
    @IBOutlet var closeButton: UIButton!

    @IBOutlet var detailContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
         closeButton.layer.borderWidth = 2
         closeButton.layer.masksToBounds = false
         closeButton.layer.borderColor = UIColor.red.cgColor
         closeButton.layer.cornerRadius = closeButton.frame.height/2
         closeButton.clipsToBounds = true
 
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        /*
         let controller = segue.destination as! TableMapViewController
         print("IS THIS WOEKING")
         print(placeNotes)
         controller.selectedPlace["Tags"] = "THIS IS CHANGING" as AnyObject
         */
        //     selectedPlace.updateValue("HELLO" as AnyObject, forKey: "Tags")
     //   let rating = ratingControl.rating
     //   print(rating)
     //   delegate?.userDidChangeRating(info3: rating)
    }
    
}
