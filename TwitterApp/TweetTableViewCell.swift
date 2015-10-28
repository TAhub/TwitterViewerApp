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
		}
	}
	var colorPoint:CGFloat
	{
		set
		{
			backgroundColor = UIColor(hue: newValue, saturation: 0.5, brightness: 1, alpha: 1)
			var textHue = newValue + 0.5
			if textHue > 1
			{
				textHue -= 1
			}
			nameLabel.textColor = UIColor(hue: textHue, saturation: 1, brightness: 1, alpha: 1)
			contentLabel.textColor = nameLabel.textColor
		}
		get
		{
			return 0 //this doesn't actually do anything
		}
	}
}
