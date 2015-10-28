//
//  TweetTableViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/26/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {

	private var tweets:[Tweet]! = [Tweet]()
	{
		didSet
		{
			tableView.reloadData()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getAccount()
		getUser()
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)

		cell.textLabel!.text = "\(tweets[indexPath.row].user!.name) (tweet ID: \(tweets[indexPath.row].id))"
		cell.detailTextLabel!.text = tweets[indexPath.row].text

        return cell
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
					self.loadNewTweets()
				}
		}
	}
	
	private func loadNewTweets()
	{
		TwitterService.getTweets()
			{ (error, tweets) in
				if let error = error
				{
					print(error)
				}
				else if let tweets = tweets
				{
					NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							self.tweets = tweets
					}
				}
		}
	}
}
