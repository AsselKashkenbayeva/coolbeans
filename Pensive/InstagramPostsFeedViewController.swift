//
//  InstagramPostsFeedViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 14/01/2018.
//  Copyright © 2018 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class InstagramPostsFeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var instagramFeedPosts: UICollectionView!
    
 
 
    override func viewDidLoad() {
        super.viewDidLoad()

        print(instagramPostsArray.count)
        for i in instagramPostsArray {
            self.saveImage(imageName: i.postID, passedURL: i.pathToImage)
        }
        DispatchQueue.main.async {
            self.instagramFeedPosts.reloadData()
            //print("This should print at the end of completed task ")
            
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  return instagramPostsArray.count
    }
    
    func saveImage(imageName: String, passedURL: String){
    
        if passedURL.isEmpty {
            //  print("There is no photo")
            return
        } else {
            let url = NSURL(string: passedURL) as! URL
            //   print("this is the passed url")
            //   print(url)
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print("THERE IS AN ERROR")
                    return
                }
                
          
                let fileManager = FileManager.default
            
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                
                let data = UIImagePNGRepresentation(UIImage(data: data!)!)
                fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
                //  }
            }).resume()
        }
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{
        
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = instagramPostsArray[indexPath.row]
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstaPostCell", for: indexPath) as! InstagramFeedCollectionViewCell
        
        cell.username.text = post.user
       
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(post.postID)
        if fileManager.fileExists(atPath: imagePath){
            cell.userPostedPhoto.image = UIImage(contentsOfFile: imagePath)
             print("I have uploaded image from internal database")
            
        }else{
              print("Panic! No Image!")
            var indicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            indicator.frame = CGRect(x: 150, y: 300, width: 100, height: 100)
            indicator.center = view.center
            indicator.bringSubview(toFront: view)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            
        }
        return cell
    }

}
