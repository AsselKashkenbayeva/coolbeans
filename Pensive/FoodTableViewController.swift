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
import CoreData
/* struct structPost {
    let title : String!
    let message : String!
}
*/
class FoodTableViewController: UITableViewController {
    
 //   let ref = FIRDatabase.database().reference(withPath: "StoredPlaces")
    
    //MARK: Properties
    var storedNames = [String]()
    var storedName = ""
    var storedPlaceIDs = [String]()
    var storedPlaceID = ""
    //var storedPlaceID: [String] = []
    var detailPlace: NSManagedObject!
    var lStoredPlaces: [NSManagedObject] = []
 
//  var posts = [post]
    // var storedPlaces: [StoredPlace] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      /*  var refHandle = self.databaseRef.child("PlaceNames").observe(FIRDataEventType.value, with: { (snapshot) in
            let placeDict = snapshot.value as? NSDictionary
            print(placeDict)
            let userDetails = placeDict?.object(forKey: self.user?.uid)
        })
        
/*     let databaseRef = FIRDatabase.database().reference()
    
    databaseRef.child("PlaceNames").queryOrderedByKey().observe(.childAdded, with: {
            FIRDataSnapshot in
          var newItems: [StoredPlace] = []
        for item in FIRDataSnapshot.children {
            let storedplace = StoredPlace(snapshot: item as! FIRDataSnapshot)
            newItems.append(storedplace)
        }
        
        self.items = newItems
        self.tableView.reloadData()
        })
    }
*/
   /*    let databaseRef = FIRDatabase.database().reference()
        
        databaseRef.child("PlaceNames").queryOrderedByKey().observe(.childAdded, with: {
            FIRDataSnapshot in
            
            let title = (FIRDataSnapshot.value as? NSDictionary)? ["title"] as? String ?? ""
           let message = (FIRDataSnapshot.value as? NSDictionary)? ["message"] as? String ?? ""
 
        })
     
    */
     /*   let rootRef = FIRDatabase.database().reference()
        
        // 2
        let childRef = FIRDatabase.database().reference(withPath: "storePlaces")
        
        // 3
        let itemsRef = rootRef.child("Places")
        
        itemsRef.observe(.value) { (snap: FIRDataSnapshot) in
            
        }
        // 4
        let nameRef = itemsRef.child("Name")
        
        // 5
        print(rootRef.key)   // prints: ""
        print(childRef.key)  // prints: "grocery-items"
        print(itemsRef.key)  // prints: "grocery-items"
        print(nameRef.key)   // prints: "milk"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
 */
 */
   /*     let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredPlace")
        
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
         */
                for result in storedPlaces
                {
                    if let name = result.value(forKey: "name") as? String
                    {
                        let storedName = name
                        self.storedName = name
                        print(storedName)
                        storedNames.append(storedName)
                        print(storedNames)
                         //print(name)
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
       
        return storedNames.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

      cell.textLabel?.text = storedNames[indexPath.row]

        
        return cell
        
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
          destination.detailPlace = storedPlaces[indexPath.row]
            //This is not correct
        }
    }

      
}

