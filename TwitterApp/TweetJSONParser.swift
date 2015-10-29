//
//  TweetJSONParser.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/26/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation

class TweetJSONParser
{
	class func tweetFromJSONData(json: NSData) -> [Tweet]?
	{
		do
		{
			if let rootObject = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers) as? [[String : AnyObject]]
			{
				var tweets = [Tweet]()
				for tweetObject in rootObject
				{
					if let tweet = singleTweetFromData(tweetObject)
					{
						tweets.append(tweet)
					}
				}
				return tweets
			}
		}
		catch
		{
			//there was an exception
		}
		
		return nil
	}
	
	private class func singleTweetFromData(json: [String : AnyObject]) -> Tweet?
	{
		if let text = json["text"] as? String, id = json["id_str"] as? String, user = json["user"] as? [String : AnyObject], userName = user["name"] as? String, profileImageURL = user["profile_image_url"] as? String
		{
			//get the original tweet
			var originalTweet:Tweet?
			if let originalTweetData = json["retweeted_status"] as? [String : AnyObject]
			{
				originalTweet = singleTweetFromData(originalTweetData)
			}
			
			let tweet = Tweet(id: id, text: text, originalTweet: originalTweet, user: User(name: userName, profileImageURL: profileImageURL))
			return tweet
		}
		return nil
	}
	
	class func userFromData(json: [String : AnyObject]) -> User?
	{
		if let name = json["name"] as? String, profileImageURL = json["profile_image_url"] as? String
		{
			return User(name: name, profileImageURL: profileImageURL)
		}
		return nil
	}
}