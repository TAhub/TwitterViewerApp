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
			refreshControl?.endRefreshing()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getAccount()
		
		//add the refresh control programmatically
		//I could do it in the interface builder but whatever, it's not really any faster or easier
		refreshControl = UIRefreshControl()
		refreshControl?.addTarget(self, action: "loadNewTweets:", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshControl!)
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)

		cell.textLabel!.text = "\(tweets[indexPath.row].user!.name) | \(tweets[indexPath.row].id)"
		cell.detailTextLabel!.text = tweets[indexPath.row].text

        return cell
    }
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 100 //for now this is a constant
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
					self.loadNewTweets(self)
				}
		}
	}
	
	func loadNewTweets(sender:AnyObject)
	{
		//this will load tweets, whether or not you have them already
		
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
