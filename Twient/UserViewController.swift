//
//  UserViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/30/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController {

     var currentTweet: Tweet!
    
    @IBOutlet weak var currentTweetImage: UIImageView!
    @IBOutlet weak var currentTweetTagline: UILabel!
    @IBOutlet weak var currentProfileRTCount: UILabel!
    @IBOutlet weak var currentProfileFollowers: UILabel!
    @IBOutlet weak var currentProfileFollowing: UILabel!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentTweetTagline.text = currentTweet.tweetUser?.tagline?.description
        
        currentProfileRTCount.text = currentTweet.tweetUser?.tweetCount?.description
        
        currentProfileFollowers.text = currentTweet.tweetUser?.followersCount?.description
        
        currentProfileFollowing.text = currentTweet.tweetUser?.followingCount?.description
        
        // setting the image of the current user in the detail user profile
        let profileImageURL = currentTweet.tweetUser?.profileUrl
        let urlString = profileImageURL?.absoluteString
        Alamofire.request(.GET, urlString!).response { (request, response, data, error) in
            self.currentTweetImage.image = UIImage(data: data!, scale:1)
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
