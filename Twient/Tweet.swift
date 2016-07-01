//
//  Tweet.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/27/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import Timepiece
import PrettyTimestamp

class Tweet: NSObject {
    
    var text: NSString?
    var timestamp: String?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var tweetUser: User?
    
    var id: Int?
    var idString : String?
    
    init(dictionary: NSDictionary){
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        id = dictionary["id"] as? Int
        idString = dictionary["id_str"] as? String
        
        
        // added lines for user information
        let userTweet = dictionary["user"] as? NSDictionary
         tweetUser = User(dictionary: userTweet!)
        
        // date formatting and setting
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
           let formatter = NSDateFormatter()
           formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
           let NSDateStamp = formatter.dateFromString(timestampString)
           let timeString = NSDateStamp?.prettyTimestampSinceNow()
           timestamp =  timeString
        } // end of timestamp manipulation
    } // end of constructor
    
    // ----------------------------------------------------------------------------------------
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
    
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    } // end of tweetsWithArray function
} // end of Tweet class
