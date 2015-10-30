//
//  TweetViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/28/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

	@IBOutlet weak var portraitButton: UIButton!
	{
		didSet
		{
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
							self.portraitButton.setBackgroundImage(image, forState: UIControlState.Normal)
						}
				}
			}
		}
	}
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var textLabel: UILabel!
	
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
		
		textLabel.text = tweet.text
		textLabel.textColor = textColor
		
		nameLabel.text = (tweet.user?.name ?? "spooky unknown person")
		nameLabel.textColor = textColor
	}
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		
		if NSUserDefaults.standardUserDefaults().boolForKey("access")
		{
			nameLabel.text = nameLabel.text!.uppercaseString
			textLabel.text = textLabel.text!.uppercaseString
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		if let dest = segue.destinationViewController as? TimelineTweetTableViewController
		{
			dest.user = tweet.user
		}
	}
}
