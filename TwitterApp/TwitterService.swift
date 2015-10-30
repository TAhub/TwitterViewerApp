//
//  TwitterService.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/27/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation
import Accounts
import Social

class TwitterService
{
	static let sharedService = TwitterService()
	
	var account: ACAccount?
	var user: User?
	
	class func getTweets(sinceId sinceId:Int?, maxId:Int?, completion: (String?, [Tweet]?) -> ())
	{
		getTweetsFromURL(urlString: "https://api.twitter.com/1.1/statuses/home_timeline.json", sinceId: sinceId, maxId: maxId, count: "8", userId: nil, completion: completion)
	}
	
	class func getTimelineTweets(forUser:User)(sinceId:Int?, maxId:Int?, completion: (String?, [Tweet]?) -> ())
	{
		getTweetsFromURL(urlString: "https://api.twitter.com/1.1/statuses/user_timeline.json", sinceId: sinceId, maxId: maxId, count: "8", userId: forUser.id, completion: completion)
	}
	
	private class func getTweetsFromURL(urlString urlString:String, sinceId:Int?, maxId:Int?, count:String, userId:String?, completion: (String?, [Tweet]?) -> ())
	{
		var parameters = [NSObject : String]()
		parameters["count"] = count
		if let userId = userId
		{
			parameters["user_id"] = userId
		}
		if let sinceId = sinceId
		{
			parameters["since_id"] = "\(sinceId)"
		}
		if let maxId = maxId
		{
			parameters["max_id"] = "\(maxId-1)"
		}
		doRequest(urlString, parameters: parameters)
			{ (error, data) in
				if let error = error
				{
					completion(error, nil)
				}
				else if let data = data
				{
					if let tweets = TweetJSONParser.tweetFromJSONData(data)
					{
						completion(nil, tweets)
					}
					else
					{
						completion("ERROR: unable to des-serialize JSON when querying \(urlString)", nil)
					}
				}
				else
				{
					completion("ERROR: unable to retrieve data somehow when querying \(urlString)", nil)
				}
		}
	}
	
	class func getAuthUser(completion: (String?, User?) -> ())
	{
		let urlString = "https://api.twitter.com/1.1/account/verify_credentials.json"
		doRequest(urlString, parameters: nil)
			{ (error, data) in
				if let error = error
				{
					completion(error, nil)
				}
				else if let data = data
				{
					do
					{
						if let userData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject], user = TweetJSONParser.userFromData(userData)
						{
							completion(nil, user)
						}
					}
					catch
					{
						completion("ERROR: unable to de-serialize JSON when querying \(urlString)", nil)
					}
				}
				else
				{
					completion("ERROR: unable to retrieve data somehow when querying \(urlString)", nil)
				}
		}
	}
	
	class func getProfileData(completion: (String?, ProfileData?) -> ())
	{
		let urlString = "https://api.twitter.com/1.1/users/show.json"
		if let user = self.sharedService.user
		{
			var parameters = [NSObject : AnyObject]()
			parameters["user_id"] = user.id
			doRequest(urlString, parameters: parameters)
				{ (error, data) in
					if let error = error
					{
						completion(error, nil)
					}
					else if let data = data
					{
						do
						{
							if let profileJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject], let profileData = TweetJSONParser.profileDataFromData(profileJSON)
							{
								completion(nil, profileData)
							}
						}
						catch
						{
							completion("ERROR: unable to de-serialize JSON when querying \(urlString)", nil)
						}
					}
					else
					{
						completion("ERROR: unable to retrieve data somehow when querying \(urlString)", nil)
					}
					
			}
		}
		else
		{
			completion("ERROR: do not have a set user when querying \(urlString)", nil)
		}
	}
	
	private class func doRequest(urlString: String, parameters: [NSObject : AnyObject]?, completion: (String?, NSData?) -> ())
	{
		//make a request and check if you have an account
		//because obviously you don't want to bother going forward if you don't have an account
		if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: NSURL(string: urlString), parameters: parameters), account = self.sharedService.account
		{
			request.account = account
			request.performRequestWithHandler()
				{ (data, response, error) -> Void in
					if let error = error
					{
						completion(error.description, nil)
					}
					else
					{
						switch(response.statusCode)
						{
						case 200...299:
							completion(nil, data)
						case 400...499:
							completion("ERROR: user error code \(response.statusCode) when querying \(urlString)", nil)
						case 500...599:
							completion("ERROR: server error code \(response.statusCode) when querying \(urlString)", nil)
						default:
							completion("ERROR: miscellaneous error code \(response.statusCode) when querying \(urlString)", nil)
							break
						}
					}
			}
		}
		else if sharedService.account == nil
		{
			completion("ERROR: do not have an account when querying \(urlString)", nil)
		}
		else
		{
			//I don't think this will ever happen, but just in case...
			completion("ERROR: unable to generate request somehow when querying \(urlString)", nil)
		}
	}
}