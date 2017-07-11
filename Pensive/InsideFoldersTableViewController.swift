//
//  FoodTableViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 18/11/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class InsideFoldersTableViewController: UITableViewController {
    var filteredStoredPlaces = [[String:AnyObject]]()
    var selectedFolder: String!
    var valueToPass = [String:AnyObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for p in STOREDPlaces {
            if p["PlaceUnderFolder"] as? String == self.selectedFolder {
               self.filteredStoredPlaces.append(p)
            }
        }

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
       
        return filteredStoredPlaces.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell()
       let placeName = filteredStoredPlaces[indexPath.row]["StoredPlaceName"]
        cell.textLabel?.text = placeName as! String?
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(folders[indexPath.row].name!)
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        let place = filteredStoredPlaces[indexPath.row]
        valueToPass = place
        self.performSegue(withIdentifier: "connectTableMapView" , sender: self)
        print(valueToPass)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "connectTableMapView") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! TableMapViewController
            // your new view controller should have property that will store passed value
            viewController.selectedPlace = valueToPass
            // print(viewController.selectedFolder)
            // print(valueToPass)
        }
    }
   // override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     //   return "Section \(section)"
  //  }
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
  
 /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
          destination.detailPlace = storedPlaces[indexPath.row]
            //This is not correct
        }
    }

    */
}

