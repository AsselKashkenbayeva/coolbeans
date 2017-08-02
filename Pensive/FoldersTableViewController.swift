//
//  FoldersTableViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 27/02/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase
import IGLDropDownMenu


class FOLDER: NSObject {
    
    var name: String?
    var icon: String?
}

class FoldersTableViewController: UITableViewController, IGLDropDownMenuDelegate {
    
    @IBOutlet weak var AddFolderTextField: UITextField!
    @IBOutlet weak var AddFolderCancelButton: UIButton!
    @IBOutlet weak var AddFolderButton: UIButton!
    @IBOutlet var AddNewFolderPopUp: UIView!
    var dropDownMenuFolder = IGLDropDownMenu()
    var dataTitle: NSArray = ["0", "1", "2", "3"]
    var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!]
   var folders: [FOLDER] = []
    var folderIndex = ""
     let user = Auth.auth().currentUser
    var valueToPass: String!
    override func viewDidLoad() {
        super.viewDidLoad()
       setupInIt()

        fetchFolder()
     //let w = UIScreen.main.bounds.width
   // let l = UIScreen.main.bounds.height
       // AddNewFolderPopUp.center = self.view.center
    }
    
    func fetchFolder() {
        let ref = Database.database().reference().child((user?.uid)!).child("UserFolders")
        ref.observe( .childAdded, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
               
        //for snap in snapshots {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                  //  let key = snap.key
                    //print(key)
                    let folder = FOLDER()
                folder.name = (dictionary["FolderName"] as? String)!
                   folder.icon = (dictionary["FolderIcon"] as? String)!
                   // print(dictionary)
                    //folder.name = dictionary["Username"] as? String
                  // print(folder.name!)
                   
                   self.folders.append(folder)
                  
                   // if self.folders.contains(folder) {
                       // print("YES")
                    //}
                        DispatchQueue.main.async {
                            
                           self.tableView.reloadData()
                        
                    }
            }
                }
              
                
        }
    )
    
        
        }

    
   override func viewWillAppear(_ animated: Bool) {
    
        
        tableView.reloadData()
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
        return folders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
let cell = UITableViewCell()
        
        let folder = folders[indexPath.row]
        cell.textLabel?.text = folder.name
      //cell.textLabel?.text = folders[indexPath.row]

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // print(folders[indexPath.row].name!)
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        valueToPass = currentCell.textLabel?.text
        self.performSegue(withIdentifier: "foldersSegue" , sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "foldersSegue") {
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! InsideFoldersTableViewController
            // your new view controller should have property that will store passed value
            viewController.selectedFolder = valueToPass
           // print(viewController.selectedFolder)
           // print(valueToPass)
        }
        /*
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? InsideFoldersTableViewController {
            // let indexPath = self.tableView.indexPathForSelectedRow()
            let index = (sender as! NSIndexPath).row
            InsideFoldersTableViewController.selectedFolder = folders[index].name!
        }
 */
    }
 
    //this is the dropdown in the pop up menu 
    func setupInIt() {
        
        var dropdownItems: NSMutableArray = NSMutableArray()
        
        for i in 0...(dataImage.count-1) {
            
            var item = IGLDropDownItem()
           // item.text = "\(dataTitle[i])"
            item.iconImage = dataImage[i]
            
            dropdownItems.add(addObject:item)
        }
        
        dropDownMenuFolder.menuText = "Icon"
        dropDownMenuFolder.dropDownItems  = dropdownItems as! [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
        dropDownMenuFolder.frame = CGRect(x: 150, y: 80, width: 70, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.stack
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
        
        
        var myLabel = UILabel()
      //  myLabel.text = "SwiftyOS Blog"
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
        myLabel.textAlignment = NSTextAlignment.center
       // myLabel.frame = CGRect(x: 40, y: 500, width: 250, height: 45)
        
        self.AddNewFolderPopUp.addSubview(myLabel)
        self.AddNewFolderPopUp.addSubview(self.dropDownMenuFolder)
        
        
    }
    
    
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
       
        let folderIndex = String(item.index)
        
        self.folderIndex = folderIndex
       
    }
    

    
   /* func getData() {
         let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
          
        folders = try context.fetch(Folder.fetchRequest())
            
            
           
        }
        catch {
            print("FAILED!")
        }
    }
*/
    @IBAction func addNewFolder(_ sender: Any) {
    
          /*  let alert = UIAlertController(title: "Name of new folder",
                                      message: "Please write the name of your new folder",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Name"
           print("\(textField.text)")
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
               //this doesn't work. it does not append the text
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                let folder = Folder(context: context)
                var textField = (alert.textFields!.first! as UITextField).text
                folder.name = textField
                
               (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
 */
      
        self.view.addSubview(AddNewFolderPopUp)
        //this is to allow the icons to be clickable
        self.view.addSubview(self.dropDownMenuFolder)
        let y = self.view.center.y
        AddNewFolderPopUp.center = CGPoint(x: self.view.center.x, y: y/2.8)
            //CGPoint(x: 180, y: 90)
        AddNewFolderPopUp.layer.borderWidth = 2
        AddNewFolderPopUp.layer.borderColor = UIColor.darkGray.cgColor
       
    }
    
    
    @IBAction func AddFolderActionButton(_ sender: Any) {
       
       
        let folderName = AddFolderTextField.text
        let folderIcon = folderIndex
       
        //this is not correct because it shows the whole array in one part
        let post : [String: AnyObject] = ["FolderName" : folderName as AnyObject, "FolderIcon" : folderIcon as AnyObject ]
        
        let databaseRef = Database.database().reference()
        
        databaseRef.child((self.user?.uid)!).child("UserFolders").childByAutoId().setValue(post)
        
        AddNewFolderPopUp.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
        let refFolders = Database.database().reference().child((user?.uid)!).child("UserFolders")
        
        refFolders.observe( .value, with: { (snapshot) in
            STOREDFolders.removeAll()
            print("here has been a new place added")
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        let key = snap.key
                        let FOLDER = (dictionary[key] as? [String: AnyObject]!)!
                        
                        STOREDFolders.append(FOLDER!)
                        
                    }
                }
            }
        }
        )

            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when) {
        let firstViewController:
                    FirstViewController = self.storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            firstViewController.folderNames.removeAll()
                for r in STOREDFolders  {
                    let folder = r["FolderName"] as? String
                  firstViewController.folderNames.append(folder!)
                }
                
               //firstViewController.sortByDropDown()
                firstViewController.setupInIt()
                print("this is printing within the dispatch time")
                print(STOREDFolders.count)
        }

                     print("this is outside the dispatch time")
            print(STOREDFolders.count)
        
    }
    
    @IBAction func AddFolderCancelButton(_ sender: Any) {
          AddNewFolderPopUp.removeFromSuperview()
        dropDownMenuFolder.removeFromSuperview()
    }
    
    
}
