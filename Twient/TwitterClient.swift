//
//  TwitterClient.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/27/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "LZnw9vUw4Mel6ol22gox08igP", consumerSecret: "AD7eweCtY0lSbqMiI2OY8vI1HvXNQwfJOZkfdZiNyyAzgsNYYR")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    
    // ------------------------------------------------------------------------------------------------------
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask,response: AnyObject?) -> Void in
        
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries) // array of dictionaries
                success(tweets)
            
            },failure: { (task: NSURLSessionDataTask?,error: NSError) -> Void in
                failure(error)
            })
        } // end of homeTimeline function
        
    // ------------------------------------------------------------------------------------------------------
    

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        
    GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response: AnyObject?) -> Void in
        let userDictionary = response as! NSDictionary
        let user = User(dictionary: userDictionary)
        success(user)
        
        }, failure:  { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
    } // end of currentAccount function
    
    // ------------------------------------------------------------------------------------------------------
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwientDemo://oauth"), scope: nil, success: { (RequesToken: BDBOAuth1Credential!) in
            print("I got a token")
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(RequesToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    } // end of login function
    
    // ------------------------------------------------------------------------------------------------------
    
    func handleOpenUrl(url: NSURL){
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            }, failure: { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        })
        
    } // end of handleOpenUrl function
    
    // ------------------------------------------------------------------------------------------------------
    
    func logout(){
        
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function is for the retweet API action
    func retweet(tweet: Tweet){
        POST("1.1/statuses/retweet/\(tweet.id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            //completion(error: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
            //completion(error: error)
        }

    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function is for the favorite API action
    func favorite(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(error: error)
        }
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function uses TW API to unfavorite a tweet
    func undoFavorite(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/destroy.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(error: error)
        }
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // function uses TW API to destroy a retweet
    func undoRetweet(id: String, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(error: error)
        }
    }
    
    // ------------------------------------------------------------------------------------------------------
    
    // this function if for composing a single tweet and posting it to the feed.
    func doTweet(params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/update.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            completion(error: nil)
        }) { (task: NSURLSessionDataTask?, error: NSError!) -> Void in
                completion(error: error)
        }
    }
    
    // ------------------------------------------------------------------------------------------------------

    
} // end of class
