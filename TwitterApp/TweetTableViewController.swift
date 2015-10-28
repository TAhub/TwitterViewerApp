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
		
		//add the refresh control programmatically
		//I could do it in the interface builder but whatever, it's not really any faster or easier
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: "loadNewTweets:", forControlEvents: UIControlEvents.ValueChanged)
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
	
	func loadOldTweets(sender:AnyObject)
	{
		//get an appropriate max_id
		var maxId:Int?
		if let tweets = tweets
		{
			for tweet in tweets
			{
				if let id = Int(tweet.id)
				{
					maxId = min(maxId ?? Int.max, id)
				}
			}
		}
		
		//scrolledToBottom is to prevent you from having a maxID and a sinceID at the same time
		//since that apparently prevents anything from happening
		TwitterService.getTweets(sinceId: nil, maxId: maxId)
			{ (error, tweets) in
				self.refreshControl!.endRefreshing()
				if let error = error
				{
					print(error)
				}
				else if let tweets = tweets
				{
					NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							//this will only ever happen if you have tweets, so no need to check
							self.tweets.appendContentsOf(tweets)
								
							//sort by ID, just in case
							self.tweets = self.tweets.sort() { Int($0.id) > Int($1.id) }
					}
				}
		}

	}
	
	func loadNewTweets(sender:AnyObject)
	{
		//get an appropriate since_id
		var sinceId:Int?
		if let tweets = tweets
		{
			for tweet in tweets
			{
				if let id = Int(tweet.id)
				{
					sinceId = max(sinceId ?? 0, id)
				}
			}
		}
		
		//scrolledToBottom is to prevent you from having a maxID and a sinceID at the same time
		//since that apparently prevents anything from happening
		TwitterService.getTweets(sinceId: sinceId, maxId: nil)
			{ (error, tweets) in
				self.refreshControl!.endRefreshing()
				if let error = error
				{
					print(error)
				}
				else if let tweets = tweets
				{
					NSOperationQueue.mainQueue().addOperationWithBlock()
						{
							if self.tweets != nil
							{
								//merge it with the old tweets
								self.tweets.appendContentsOf(tweets)
								
								//sort by ID, just in case
								self.tweets = self.tweets.sort() { Int($0.id) > Int($1.id) }
							}
							else
							{
								self.tweets = tweets
							}
					}
				}
		}
	}
}
