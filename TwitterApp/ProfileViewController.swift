//
//  ProfileViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/29/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

	private var profileData:ProfileData?
	{
		didSet
		{
			if nameLabel != nil && followerLabel != nil && descriptionLabel != nil
			{
				if let profileData = profileData
				{
					nameLabel.text = "\(profileData.name) (\(profileData.screenName))"
					followerLabel.text = "\(profileData.followers) follower\(profileData.followers == 1 ? "" : "s")"
					descriptionLabel.text = profileData.description
				}
				else
				{
					nameLabel.text = "sorry"
					followerLabel.text = "can't see your profile when you aren't logged on"
					descriptionLabel.text = "hope you have a good day"
				}
			}
		}
	}
	
	@IBOutlet weak var profileView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var followerLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		if profileData == nil
		{
			//try to load up profile data every time you go to this screen
			//since there's a chance it won't work, so it'll be nice to re-try
			TwitterService.getProfileData()
				{ (error, profile) in
					if let error = error
					{
						print(error)
						self.profileData = nil
					}
					else if let profile = profile
					{
						NSOperationQueue.mainQueue().addOperationWithBlock()
							{
								self.profileData = profile
						}
					}
			}
		}
	}
}
