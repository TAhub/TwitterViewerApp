//
//  Tweet.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/26/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation

class Tweet
{
	let id:String
	let text:String
	let originalTweet:Tweet?
	let user:User?
	
	init(id:String, text:String, originalTweet:Tweet?, user:User?)
	{
		self.id = id
		self.text = text
		self.originalTweet = originalTweet
		self.user = user
	}
}