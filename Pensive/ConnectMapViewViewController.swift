//
//  ConnectMapViewViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 30/04/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class ConnectMapViewViewController: UIViewController {

    @IBOutlet var friendProfilePic: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
 friendProfilePic.image = UIImage(named: "b")
   
        // Do any additional setup after loading the view.
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
