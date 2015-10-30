//
//  TweetTableViewCell.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/28/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var profileImage: UIImageView!
	
	var tweet:Tweet!
	{
		didSet
		{
			nameLabel.text = tweet.user?.name ?? "spooky unknown user"
			contentLabel.text = tweet.text
			if let profileImageURL = tweet.user?.profileImageURL
			{
				ImageHandler.fetchImage(profileImageURL)
					{ (error, image) in
						if let error = error
						{
							print(error)
						}
						else
						{
							self.profileImage.image = image
						}
				}
			}
			
			if NSUserDefaults.standardUserDefaults().boolForKey("access")
			{
				nameLabel.text = nameLabel.text!.uppercaseString
				contentLabel.text = contentLabel.text!.uppercaseString
			}
		}
	}
	var colorPoint:CGFloat
	{
		set
		{
			let defaults = NSUserDefaults.standardUserDefaults()
			
			let saturation = CGFloat(0.25 + defaults.floatForKey("saturation") * 0.5)
			
			backgroundColor = UIColor(hue: newValue, saturation: saturation, brightness: 1, alpha: 1)
			var textHue = newValue + 0.5
			if textHue > 1
			{
				textHue -= 1
			}
			nameLabel.textColor = UIColor(hue: textHue, saturation: saturation + 0.25, brightness: 1, alpha: 1)
			contentLabel.textColor = nameLabel.textColor
		}
		get
		{
			return 0 //this doesn't actually do anything
		}
	}
}
