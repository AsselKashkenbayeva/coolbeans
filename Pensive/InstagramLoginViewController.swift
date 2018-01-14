//
//  InstagramLoginViewController.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 19/12/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit
import SwiftyJSON

class InstagramLoginViewController: UIViewController {

    @IBOutlet var instagramLoginWebview: UIWebView!
    
    @IBOutlet var closeIntroButton: UIButton!
     var instaToken = ""
    @IBAction func closeIntroButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        instagramLoginWebview.loadRequest(urlRequest)
        
        /* let recommendationsURL = NSURL(string: "https://www.cattche.com/instagram")
         let request = NSURLRequest(url: recommendationsURL! as URL)
         webView.loadRequest(request as URLRequest);
         */

        // Do any additional setup after loading the view.
          instagramLoginWebview.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension InstagramLoginViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return checkRequestForCallbackURL(request: request)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            
            return false;
        }
        return true
    }
    func handleAuth(authToken: String) {
        self.instaToken = authToken
        print("Instagram authentication token ==", authToken)
        print(authToken)
        print(API.INSTAGRAM_SCOPE)
        getInstaData()
    }
    
    func getInstaData() {
        let insta = "https://api.instagram.com/v1/users/self/media/liked?access_token=\(instaToken)"
        let urlString = URL(string: insta)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        print("userdataTRHH\(usableData)") //JSONSerialization
                       
                        let json = try?JSON(usableData)
                        
                print(json)
                      
                        
                        }
                    }
                }
            
            task.resume()
            
        }
        if instaToken == "" {
            print("I have not got the instatoken yet")
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}


