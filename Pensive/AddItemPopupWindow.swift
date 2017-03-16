//
//  AddItemPopupWindow.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 01/03/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

    import UIKit
    import FirebaseDatabase
    import IGLDropDownMenu
    
    class AddItemPopupWindow: UIView,IGLDropDownMenuDelegate {
        
        var dropDownMenuFolder = IGLDropDownMenu()
        var dataTitle: NSArray = ["Restaurant", "Museum", "Landmarks", "Favourites"]
        override init (frame : CGRect) {
            super.init(frame: frame)
            setupInIt()
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
        func setupInIt() {
            
            var dropdownItems: NSMutableArray = NSMutableArray()
            
            for i in 0...(dataTitle.count-1) {
                
                var item = IGLDropDownItem()
                item.text = "\(dataTitle[i])"
                dropdownItems.add(addObject:item)
            }
            
            dropDownMenuFolder.menuText = "Choose Folder"
            dropDownMenuFolder.dropDownItems  = dropdownItems as! [AnyObject]
            dropDownMenuFolder.paddingLeft = 15
            dropDownMenuFolder.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
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
            myLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 45)
            // myLabel.bounds = CGRect(x: -10, y: -70, width: 200, height: 45)
            
           let boblabel = UILabel()
            boblabel.frame.origin.y -= 250.0
            boblabel.backgroundColor = UIColor.black
            boblabel.text = "HEllo"
        addSubview(myLabel)
           addSubview(self.dropDownMenuFolder)
            addSubview(boblabel)
            print("IT IS WORKING")
        }
        
        
        func dropDownMenu(dropDownMenu: IGLDropDownMenu!, selectedItemAtIndex index: Int) {
            
            var item:IGLDropDownItem = dropDownMenu.dropDownItems[index] as! IGLDropDownItem
            print("Selected weather")
            
        }
        
  //  }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */


}
