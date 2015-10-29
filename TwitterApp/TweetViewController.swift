//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/28/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

	@IBOutlet weak var nameLabel: UILabel!
	{
		didSet
		{
			nameLabel.text = (tweet.user?.name ?? "spooky unknown person")
			nameLabel.textColor = textColor
		}
	}
	@IBOutlet weak var textLabel: UILabel!
	{
		didSet
		{
			textLabel.text = tweet.text
			textLabel.textColor = textColor
		}
	}
	
	var tweet:Tweet!
	{
		didSet
		{
			if let ogTweet = tweet?.originalTweet
			{
				tweet = ogTweet
			}
		}
	}
	var textColor:UIColor?
	var backgroundColor:UIColor?
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		view.backgroundColor = backgroundColor
	}
}
