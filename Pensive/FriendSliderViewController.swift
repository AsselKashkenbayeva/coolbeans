//
//  FriendSliderViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 10/09/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import Firebase


class FriendSliderViewController: UIViewController {
    /*
  //UICollectionViewDelegate, UICollectionViewDataSource
    
    // var dataImage: [UIImage] = [UIImage(named: "0")!, UIImage(named: "1")!, UIImage(named:"2")!, UIImage(named: "3")!, UIImage(named: "5")!, UIImage(named: "6")!]
    
   
   //   var user = Auth.auth().currentUser
   // var allFilters: [FILTER] = []
  //  let mygroup = DispatchGroup()

    @IBOutlet var collectionViewWindow: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    self.collectionViewWindow.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionViewWindow.reloadData()
        print("will appear view")
    }
    
    
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("this is the all filters count")
        
        let firstViewController:
            FirstViewController = self.storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
        var friendCells = firstViewController.getFriends()
     print("this is in cthe container view\(friendCells)")
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      //let filter = allFilters[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.friendProfileImage.image = UIImage(named: "funProfileIcon")
        /*
        if filter.type == "folder" {
          
        } else {
            let fileManager = FileManager.default
            
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(filter.path!)
            print(imagePath)
            if fileManager.fileExists(atPath: imagePath){
                cell.friendProfileImageFromMap.image = UIImage(contentsOfFile: imagePath)
                print("I have uploaded image from internal database")
            }else{
                print("Panic! No Image!")
                cell.friendProfileImageFromMap.image = UIImage(named: "funProfileIcon")
            }
        }
 */
        //cell.nameForLabelMap.text = filter.name
        return cell

    }
  
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        let selectedFilter = allFilters[indexPath.row]
        if selectedFilter.type == "folder" {
            let firstViewController:
                FirstViewController = self.storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
            firstViewController.filterSelected = selectedFilter.name!
            firstViewController.filterPlaces()
            
       //firstViewController.vwGMap.addSubview(firstViewController.detailsPopUp)
        } else {
            
        }
        
       */
    }
 */
}

