//
//  TweetTableViewController.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/26/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController {

	var tweets:[Tweet]! = [Tweet]()
	{
		didSet
		{
			tableView.reloadData()
		}
	}
	
	var getTweetsFunction:((Int?, Int?, (String?, [Tweet]?) -> ()) -> ())!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//make the background a netural gray, for the beautiful rainbow
		view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.5, alpha: 1)
		//oh yeah and make the row height good I guess
		tableView.estimatedRowHeight = 100
		tableView.rowHeight = UITableViewAutomaticDimension
		
		//add the refresh control programmatically
		//I could do it in the interface builder but whatever, it's not really any faster or easier
		refreshControl = UIRefreshControl()
		refreshControl!.addTarget(self, action: "loadNewTweets:", forControlEvents: UIControlEvents.ValueChanged)
		tableView.addSubview(refreshControl!)
		
		//register the real view controller
		let nib = UINib(nibName: "TweetTableViewCell", bundle: nil)
		tableView.registerNib(nib, forCellReuseIdentifier: "TweetCell")
	}

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTableViewCell

		cell.tweet = tweets[indexPath.row]
		cell.colorPoint = CGFloat(Double(indexPath.row % 12) / 12.0)
		
        return cell
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		performSegueWithIdentifier("showTweet", sender: tableView.cellForRowAtIndexPath(indexPath))
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showTweet"
		{
			if let sender = sender as? TweetTableViewCell, destination = segue.destinationViewController as? TweetViewController
			{
				//give it the tweet
				destination.tweet = tweets[tableView.indexPathForCell(sender)!.row]
				
				//and give it a pretty color
				destination.textColor = sender.nameLabel.textColor
				destination.backgroundColor = sender.backgroundColor
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
		//TwitterService.getTweets(sinceId: nil, maxId: maxId)
		getTweetsFunction(nil, maxId)
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
		
		//TwitterService.getTweets(sinceId: sinceId, maxId: nil)
		getTweetsFunction(sinceId, nil)
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
