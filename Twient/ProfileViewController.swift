//
//  ProfileViewController.swift
//  Twient
//
//  Created by Juan Luis Herrero Estrada on 6/30/16.
//  Copyright © 2016 Juan Luis Herrero Estrada. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    var currentUser: User!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userTaglineLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userTaglineLabel.text = User.currentUser?.tagline?.description
        tweetsLabel.text = User.currentUser?.tweetCount?.description
        followersLabel.text = User.currentUser?.followersCount?.description
        followingLabel.text = User.currentUser?.followingCount?.description
        
        // setting the image of the current user in the detail user profile
        let profileImageURL = User.currentUser!.profileUrl
        let urlString = profileImageURL?.absoluteString
        Alamofire.request(.GET, urlString!).response { (request, response, data, error) in
            self.profileImageView.image = UIImage(data: data!, scale:1)
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
