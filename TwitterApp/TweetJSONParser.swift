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
				print("ROOTOBJECT: \(rootObject)")
				
				var tweets = [Tweet]()
				for tweetObject in rootObject
				{
					if let text = tweetObject["text"] as? String, id = tweetObject["id_str"] as? String, user = tweetObject["user"] as? [String : AnyObject], userName = user["name"] as? String, profileImageURL = user["profile_image_url_https"] as? String
					{
						let tweet = Tweet(id: id, userName: userName, profileImageURL: profileImageURL, text: text)
						tweets.append(tweet)
					}
				}
				return tweets
			}
		}
		catch _
		{
			//TODO: catch an exception I guess
		}
		
		return nil
	}
}