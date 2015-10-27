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
			{_,_ in 
				print("SUCCESS")
		}
	}
	
	private func getUser()
	{
		//TODO: this doesn't seem to be working (probably the fault of twitter service)
		TwitterService.getAuthUser()
			{ (error, user) -> () in
				print(user?.name)
				self.loadNewTweets()
		}
	}
	
	private func loadNewTweets()
	{
		//TODO: this should load real tweets
		if let tweetJSONFileUrl = NSBundle.mainBundle().URLForResource("tweet", withExtension: "json")
		{
			print("URL: \(tweetJSONFileUrl)")
			
			if let tweetJSONData = NSData(contentsOfURL: tweetJSONFileUrl)
			{
				print("JSON: \(tweetJSONData)")
				
				if let tweets = TweetJSONParser.tweetFromJSONData(tweetJSONData)
				{
					print("TWEETS: \(tweets)")
					
					self.tweets = tweets
				}
			}
		}
	}
}
