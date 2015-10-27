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
	
	class func getAuthUser(completion: (String?, User?) -> ())
	{
		let url = NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!
		
		if let request = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
		{
			if let account = self.sharedService.account
			{
				request.account = account
				
				request.performRequestWithHandler()
					{ (data, response, error) -> Void in
						if response.statusCode == 200
						{
							do
							{
								if let userData = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String: AnyObject], user = TweetJSONParser.userFromData(userData)
								{
									completion(nil, user)
								}
							}
							catch _
							{
								//TODO: catch an exception
							}
						}
				}
			}
		}
	}
}