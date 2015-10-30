//
//  TimelineTweetTableViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/29/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TimelineTweetTableViewController: TweetTableViewController {

	var user:User!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getTweetsFunction = TwitterService.getTimelineTweets(user)
		//getTweetsFunction = TwitterService.getTweets
		loadNewTweets(self)
	}
}
