//
//  TweetTableViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/26/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class HomeTweetTableViewController: TweetTableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		getTweetsFunction = TwitterService.getTweets
		getAccount()
		
		//get temporary tweets
		//because I keep getting 429 errors
//		for i in 0..<20
//		{
//			var text = "TEST"
//			for _ in 0..<Int(Double(i) * 1.5)
//			{
//				text += " FILLER"
//			}
//			tweets.append(Tweet(id: "\(i)", text: text, originalTweet: nil, user: User(name: "tester", id: "a", profileImageURL: "a")))
//		}
	}
	
	private func getAccount()
	{
		LoginService.loginToTwitter()
			{(error, account) in
				if let error = error
				{
					print(error)
				}
				else if let account = account
				{
					TwitterService.sharedService.account = account
					self.getUser()
				}
		}
	}
	
	private func getUser()
	{
		TwitterService.getAuthUser()
			{ (error, user) -> () in
				if let error = error
				{
					print(error)
				}
				else
				{
					TwitterService.sharedService.user = user
					self.loadNewTweets(self)
				}
		}
	}
	
	override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
	{
		//if you're about to display the final cell, and you aren't doing anything
		//then load new tweets
		//it's a little hacky but hey
		if indexPath.row == tweets.count - 1 && !refreshControl!.refreshing
		{
			loadOldTweets(self)
			refreshControl!.beginRefreshing()
		}
	}
}
