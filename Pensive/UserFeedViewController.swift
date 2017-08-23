//
//  UserFeedViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 12/08/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

class UserFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var users = [USER]()
    @IBOutlet var UserfeedTableView: UITableView!
    
    @IBOutlet var addFriendsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
UserfeedTableView.delegate = self
UserfeedTableView.dataSource = self
        fetchUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func fetchUser() {
        let ref = Database.database().reference()
        ref.observe( .childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
              
            /*
                let user = USER()
                user.Username = dictionary["Username"]?["Username"] as? String
                user.ProfilePicURL = dictionary["ProfilePicURL"]?["ProfilePicURL"] as? String
              // doesnt handle if people dont have stored places node yet 
                user.StoredPlacesOfUser = (dictionary["StoredPlaces"] as? [String:AnyObject])!
            
                user.StoredFoldersOfUser = (dictionary["UserFolders"] as? [String:AnyObject])!
                
                self.users.append(user)
                print(self.users)
 */
 
                DispatchQueue.main.async {
                 self.UserfeedTableView.reloadData()
                }
            }
        }
        )}

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = UITableViewCell()
        // let cell: UserCell = UserCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
    /*
        let user = users[indexPath.row]
        cell.textLabel?.text = user.Username
        cell .detailTextLabel?.text = user.Email
        cell.imageView?.image = imageWithImage(image: UIImage(named: "a")!, scaledToSize: CGSize(width: 40, height: 40))
        if let profileImageURL = user.ProfilePicURL {
            let url = URL(string: profileImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    print("THIS IS GOING TO BE A PIC")
                    cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
        
        cell.imageView?.sizeToFit()
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.masksToBounds = false
        cell.imageView?.layer.borderColor = UIColor.orange.cgColor
        cell.imageView?.layer.cornerRadius = 70
        cell.imageView?.clipsToBounds = true
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 5, height: 5)
        */
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        // Segue to the second view controller
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ConnectMapViewController") as! ConnectMapViewViewController
        myVC.selectedUser = users[indexPath.row]
        // self.performSegue(withIdentifier: "connectMapView", sender: self)
        navigationController?.pushViewController(myVC, animated: true)
        */
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBOutlet var addFriendsAction: UIButton!

}
