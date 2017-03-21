//
//  ConnectTableViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 20/03/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase

    class ConnectTableViewController: UITableViewController {
        
       
    override func viewDidLoad() {
        super.viewDidLoad()
 let ref = FIRDatabase.database().reference()
       refHandle = ref.observe(.childAdded, with: { (snapshot) in
        if let Dictionary = snapshot.value as? String {
            print(Dictionary)
            let user = USER()
            user.setNilValueForKey(Dictionary)
            self.userList.append(user)
            
            self.tableView.reloadData()
         
        }
       })
      
   
        ref.queryOrderedByKey().observe(.childAdded, with: { (snapshot) in
            if let username = (snapshot.value as? NSDictionary)?["Username"] as? String {
                print("\(snapshot.key) was \(username)")
            }
        })
        
        
        
        
        
        
      navigationItem.title = "User Feed"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return 4
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ConnectTableViewCellController
        
        //cell.userUsername?.text = username[indexPath.row]
        cell.userPhoto?.image = UIImage(named: "")
        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
