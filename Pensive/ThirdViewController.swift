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

    @IBOutlet var labeltest: UILabel!
    @IBOutlet var secondView: UIView!
    @IBOutlet var firstView: UIView!
    var dropDownMenuFolder = IGLDropDownMenu()
    var dataTitle: NSArray = ["Restaurant", "Museum", "Landmarks", "Favourites"]
    
    @IBAction func closebutton(_ sender: Any) {
        secondView.removeFromSuperview()
    }
    let gradientLayer = CAGradientLayer()
    var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!]
    override func viewDidLoad() {
        super.viewDidLoad()
        
            
            self.view.backgroundColor = UIColor.blue
            gradientLayer.frame = self.view.bounds

        let color1 = UIColor.yellow.cgColor
        let color2 = UIColor.black.cgColor
        gradientLayer.colors = [color1,color2]
        gradientLayer.locations = [0.7,1]
        self.view.layer.addSublayer(gradientLayer)
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
        dropDownMenuFolder.frame = CGRect(x: secondView.frame.origin.x+200 , y: secondView.frame.origin.y+10, width: 200, height: 45)
       // dropDownMenuFolder.bounds = CGRect(x: -10, y: -70, width: 200, height: 45)
        dropDownMenuFolder.delegate = self
        dropDownMenuFolder.type = IGLDropDownMenuType.slidingInBoth
        dropDownMenuFolder.gutterY = 5
        dropDownMenuFolder.itemAnimationDelay = 0.1
        dropDownMenuFolder.reloadView()
        dropDownMenuFolder.direction = IGLDropDownMenuDirection.up
        /*
        var myLabel = UILabel()
       // myLabel.text = "SwiftyOS Blog"
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont(name: "Halverica-Neue", size: 17)
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.frame = CGRect(x: secondView.frame.origin.x+200 , y: secondView.frame.origin.y+10 , width: 200, height: 45)
       // myLabel.bounds = CGRect(x: -10, y: -70, width: 200, height: 45)
        
        secondView.addSubview(myLabel)
        */
     secondView.addSubview(self.dropDownMenuFolder)
        
    }
    
    
    func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
        
        var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
        print("Selected weather")
        
    }

    @IBAction func showSubview(_ sender: Any) {
    firstView.addSubview(secondView)
       // secondView.center = CGPoint(x: 150, y: 590)
  let bob = firstView.bounds.width
        let bkb = firstView.bounds.height
         secondView.center = CGPoint(x: bob/2, y: bkb)
    let l = "THIS TEST"
        labeltest.text =  ("which folder would you like to add \(l) to ?" )
        print(bob,bkb)
        
    }
}
