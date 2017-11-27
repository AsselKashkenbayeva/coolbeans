//
//  containerviewtestViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 01/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class containerviewtestViewController: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet var tapGestureaction: UITapGestureRecognizer!

    @IBOutlet var gestureRecognizer: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    
    
    @IBAction func panning(_ sender: Any) {
        if gestureRecognizer.state == .possible || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        print("panning")
    }
    @IBAction func tapGesture(_ sender: Any) {
        print("Tapped")
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
