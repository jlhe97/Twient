//
//  ComposeViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/29/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var charactersLeftLabel: UILabel!
    
    let maxChar = 140
    var currentTweetUsername: String?
    
    // ---------------------------------------------------------------------------------------------

    @IBAction func postTweet(sender: AnyObject) {
        
        let status = self.composeTextView.text
        if status.characters.count > 0 {
            TwitterClient.sharedInstance.doTweet(status)
        }
        
        
        
    }
    
    // ---------------------------------------------------------------------------------------------


    override func viewDidLoad() {
        super.viewDidLoad()

        self.charactersLeftLabel.text = maxChar.description
        self.composeTextView.becomeFirstResponder()
        composeTextView.layer.cornerRadius = 5
        composeTextView.layer.borderColor = UIColor.blackColor().CGColor
        composeTextView.layer.borderWidth = 1
        
        if let currentTweetUsername = currentTweetUsername {
        composeTextView.text = "@" + (currentTweetUsername) + " "
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    
    func maxCharChange(textView: UITextView) {
        let status = composeTextView.text
        let charRemaining = maxChar - status.characters.count
        print ("\(charRemaining)")
        self.charactersLeftLabel.text = charRemaining.description
        self.charactersLeftLabel.textColor = charRemaining >= 0 ? .lightGrayColor() : .redColor()
    }
    
    // ---------------------------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


} // end of ComposeViewController class
