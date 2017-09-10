//
//  TestingOutstuffViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 25/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class TestingOutstuffViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet var FriendPopUpView: UIView!

   
    @IBOutlet var containerview: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(withDuration: 2, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.FriendPopUpView.frame = CGRect(x: 0 , y: 20, width: self.FriendPopUpView.frame.width, height: self.FriendPopUpView.frame.height)
            
            
        },completion: { finish in
            
            UIView.animate(withDuration: 2, delay: 0.25,options: UIViewAnimationOptions.curveEaseOut,animations: {
                self.FriendPopUpView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            },completion: nil)})
        print(childViewControllers)
        
   // containerView.frame = CGRect(x: 10, y: 100, width: 20, height: 20)
        
        /*
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.FriendPopUpView.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "swiped:") // put : at the end of method name
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.FriendPopUpView.addGestureRecognizer(swipeLeft)
 */
    }
    /*
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right :
                print("User swiped right")
                
                /*No clue how to make it go back to the previous image and
                 when it hits the last image in the array, it goes back to
                 the first image.. */
                
            case UISwipeGestureRecognizerDirection.left:
                print("User swiped Left")
                
            }
        }
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

