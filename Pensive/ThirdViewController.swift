//
//  ThirdViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 25/10/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import IGLDropDownMenu
import Firebase

class ThirdViewController: UIViewController, IGLDropDownMenuDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var addFriendsWindowView: UIView!
    
    @IBOutlet var newFolderTextField: UITextField!
    
    @IBOutlet var addFolderButton: UIButton!
    
      var dropDownMenuFolder = IGLDropDownMenu()
    
      var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!, UIImage(named: "5")!, UIImage(named: "6")!]
      var folderIndex = ""
    
       let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInIt()

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDown)
        addFolderButton.isUserInteractionEnabled = false
        addFolderButton.setImage(UIImage(named: "addIconGrey"), for: UIControlState.normal)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
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
        dropDownMenuFolder.frame = CGRect(x: 150, y: 150, width: 50, height: 50)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.slidingInBoth
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
      
        self.view.addSubview(dropDownMenuFolder)
    }
    
    
    func dropDownMenu(_ dropDownMenu: IGLDropDownMenu!, selectedItemAt index: Int) {
        
        var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        
        let folderIndex = String(item.index)
        
        self.folderIndex = folderIndex
        addFolderButton.isUserInteractionEnabled = true
     addFolderButton.setImage(UIImage(named: "addIcon"), for: UIControlState.normal)
    }
    
    @IBAction func addFolderAction(_ sender: Any) {
        
        let folderName = newFolderTextField.text
        let folderIcon = folderIndex
        
        //this is not correct because it shows the whole array in one part
        let post : [String: AnyObject] = ["FolderName" : folderName as AnyObject, "FolderIcon" : folderIcon as AnyObject ]
        
        let databaseRef = Database.database().reference()
        databaseRef.child((self.user?.uid)!).child("UserFolders").childByAutoId().setValue(post)
        
        //dropDownMenuFolder.removeFromSuperview()
        self.dismiss(animated: true, completion: nil)
    }
    

    
}
