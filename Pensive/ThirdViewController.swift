//
//  ThirdViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 25/10/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import FirebaseDatabase
import IGLDropDownMenu

class ThirdViewController: UIViewController,IGLDropDownMenuDelegate {

    var dropDownMenuFolder = IGLDropDownMenu()
    var dataTitle: NSArray = ["Restaurant", "Museum", "Landmarks", "Favourites"]
    
    var dataImage: [UIImage] = [UIImage(named: "restIcon")!, UIImage(named: "museumIcon")!, UIImage(named:"landmarksIcon")!, UIImage(named: "favIcon")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInIt()
        
        
    }
    
    func setupInIt() {
        
        var dropdownItems: NSMutableArray = NSMutableArray()
        
        for i in 0...(dataTitle.count-1) {
            
            var item = IGLDropDownItem()
            item.text = "\(dataTitle[i])"
            item.iconImage = dataImage[i]
            dropdownItems.add(addObject:item)
        }
        /*for element in dataImage {
            var item = IGLDropDownItem()
            item.iconImage = element
        }

        */
        dropDownMenuFolder.menuText = "Choose Folder"
        dropDownMenuFolder.dropDownItems  = dropdownItems as! [AnyObject]
        dropDownMenuFolder.paddingLeft = 15
        dropDownMenuFolder.frame = CGRect(x: 75, y: 250, width: 200, height: 45)
       // dropDownMenuFolder.bounds = CGRect(x: -10, y: -70, width: 200, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.stack
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
        
        var myLabel = UILabel()
       // myLabel.text = "SwiftyOS Blog"
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.frame = CGRect(x: 75, y: 250, width: 200, height: 45)
       // myLabel.bounds = CGRect(x: -10, y: -70, width: 200, height: 45)
        
        self.view.addSubview(myLabel)
        self.view.addSubview(self.dropDownMenuFolder)
        
    }
    
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        
        var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        print("Selected weather")
        
    }

}
