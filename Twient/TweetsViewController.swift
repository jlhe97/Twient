//
//  TweetsViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/27/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet] = []
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    // ------------------------------------------------------------------------------------------------------
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function is in charge of fetching all the info to be placed in the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        let profileImageURL = tweet.tweetUser?.profileUrl
        let urlString = profileImageURL?.absoluteString
        
        let tweetText = tweet.text?.description
        let username = tweet.tweetUser?.screenname?.description
        let timestamp = tweet.timestamp
        
        // FAVs and RTs
        let tweetRT = tweet.retweetCount.description
        let tweetFV = tweet.favoriteCount.description
        
        // Alamofire retrieves the image from the url and sets it equal to the UIImage in the tweet
        Alamofire.request(.GET, urlString!).response { (request, response, data, error) in
            cell.profileImageView.image = UIImage(data: data!, scale:1)
        }
        
        cell.tweetTextLabel.text = tweetText
        cell.usernameLabel.text = username
        cell.timestampLabel.text = timestamp
        cell.retweetCountLabel.text = tweetRT
        cell.favoriteCountLabel.text = tweetFV
        
        return cell
    } // end of cellForRowAtIndexPath function
    
    // ------------------------------------------------------------------------------------------------------
    
    func fetchTweets(){
        
        TwitterClient.sharedInstance.homeTimeline({ (Tweets: [Tweet]) -> () in
            self.tweets = Tweets
            self.tweetTableView.reloadData()
        }) { (error: NSError) -> () in
            print("error: \(error.localizedDescription)")
        }
        
    } // this function gets the tweets from JSON dictionaries
    
    // ------------------------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.delegate = self
        tweetTableView.dataSource = self
        fetchTweets()
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetTableView.insertSubview(refreshControl, atIndex: 0)
        
    } // end of view did load function
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function is used to do pull for refresh.
    func refreshControlAction(refreshControl: UIRefreshControl) {
        fetchTweets()
        refreshControl.endRefreshing()
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function sends information over to the view controller that shows the details of the image.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tweetTableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.singleTweet = tweet
        } else if segue.identifier == "tweetProfileSegue" {
            let button = sender as! UIButton
            let contentView = button.superview
            let cell = contentView?.superview as! TweetCell
            
            let indexPath = tweetTableView.indexPathForCell(cell)
            let tweet = tweets[(indexPath!.row)]
            let userViewController = segue.destinationViewController as! UserViewController
            userViewController.currentTweet = tweet
        }
        
    }
    
    
    
} // end of TweetsViewController class
