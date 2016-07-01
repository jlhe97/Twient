//
//  DetailViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/29/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import Alamofire
import PrettyTimestamp

class DetailViewController: UIViewController {

    var singleTweet: Tweet!
    
    @IBOutlet weak var detailProfileImage: UIImageView!
    @IBOutlet weak var detailUsernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var detailTweetLabel: UILabel!
    @IBOutlet weak var detailRTLabel: UILabel!
    @IBOutlet weak var detailFAVLabel: UILabel!
    
    // --------------------------------------------------
    
    // function is supposed to increase retweet amount
    @IBAction func didRTAction(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweet(singleTweet)
            if self.singleTweet.retweetCount >= 0 {
                self.detailRTLabel.text = "\(self.singleTweet.retweetCount + 1)"
            }
        
        
    }
    
    // --------------------------------------------------
    
    // function is supposed to increase favorite amount
    @IBAction func didFAVAction(sender: AnyObject) {
        TwitterClient.sharedInstance.favorite(singleTweet.idString!, params: nil) { (error) in
            
            if self.singleTweet.favoriteCount >= 0 {
                self.detailFAVLabel.text = "\(self.singleTweet.favoriteCount + 1)"
            }
        }
        
    
    }
   
    
    // --------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let profileImageURL = singleTweet.tweetUser?.profileUrl
        let urlString = profileImageURL?.absoluteString
        
        let tweetText = singleTweet.text?.description
        let username = singleTweet.tweetUser?.screenname?.description
        let timestamp = singleTweet.timestamp
        
        // FAVs and RTs
        let tweetRT = singleTweet.retweetCount.description
        let tweetFV = singleTweet.favoriteCount.description
        
        // Alamofire retrieves the image from the url and sets it equal to the UIImage in the tweet
        Alamofire.request(.GET, urlString!).response { (request, response, data, error) in
            self.detailProfileImage.image = UIImage(data: data!, scale:1)
        }
        
        self.detailTweetLabel.text = tweetText
        self.detailUsernameLabel.text = username
        self.timestampLabel.text = timestamp
        self.detailRTLabel.text = tweetRT
        self.detailFAVLabel.text = tweetFV

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

} // end of DetailViewController class
