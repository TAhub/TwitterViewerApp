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
			if nameLabel != nil
			{
				if let profileData = profileData
				{
					nameLabel.text = profileData.name
					screenNameLabel.text = "@\(profileData.screenName)"
					descriptionLabel.text = profileData.description
					locationLabel.text = "location: \(profileData.location)"
					ImageHandler.fetchImage(profileData.profileImageURL)
						{ (error, image) in
							if let error = error
							{
								print(error)
							}
							else
							{
								self.profileView.image = image
							}
					}
					ImageHandler.fetchImage(profileData.profileBackgroundImageURL)
						{ (error, image) in
							if let error = error
							{
								print(error)
							}
							else
							{
								self.backgroundImageView.image = image
							}
					}
				}
				else
				{
					nameLabel.text = "sorry"
					screenNameLabel.text = "this won't work if you don't sign in to twitterß"
					descriptionLabel.text = "hope you have a good day"
					locationLabel.text = "bye"
					profileView.image = nil
				}
			}
		}
	}
	
	@IBOutlet weak var profileView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var screenNameLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var backgroundImageView: UIImageView!
	
	
	
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
