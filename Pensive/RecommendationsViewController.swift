//
//  RecommendationsViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 17/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

class RecommendationsViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    
    @IBOutlet var addRecommendationButton: UIButton!
    
    var dictionary = [String: AnyObject]()
    var cattchefolderexists = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let recommendationsURL = NSURL(string: "https://www.cattche.com/new-page")
        let request = NSURLRequest(url: recommendationsURL! as URL)
        webView.loadRequest(request as URLRequest);
        
        let ref = Database.database().reference().child("AddRecommendation")
        
        ref.observe( .value, with: { (snapshot) in
        self.dictionary = (snapshot.value as? [String: AnyObject])!
            print(self.dictionary)
       
            }
    )
webView.isUserInteractionEnabled = false
        for p in STOREDFolders {
            let item = p["FolderName"] as? String
            print(item)
            if item == "Cattche Recommendations"  {
            self.cattchefolderexists = true
                print(self.cattchefolderexists)
            } else {
                print("WE HAVE NO CATTCHE")
            }
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
   
    @IBAction func addRecommendationAction(_ sender: Any) {
    var user = Auth.auth().currentUser
    let databaseRef = Database.database().reference()
    databaseRef.child((user?.uid)!).child("StoredPlaces").childByAutoId().setValue(self.dictionary)
      
        for p in STOREDFolders {
            let item = p["FolderName"] as? String
            print(item)
            if item == "Cattche Recommendations"  {
                self.cattchefolderexists = true
                print(self.cattchefolderexists)
            } else {
                print("WE HAVE NO CATTCHE")
            }
        }
    
        if cattchefolderexists == false {
          let post : [String: AnyObject] = ["FolderName" : "Cattche Recommendations" as AnyObject, "FolderIcon" : "3" as AnyObject ]
    databaseRef.child((user?.uid)!).child("UserFolders").childByAutoId().setValue(post)
            
        } else {
            print("We already have a cattche folder")
        }
}
}
