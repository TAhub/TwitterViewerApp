//
//  LoginService.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/27/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation
import Accounts

class LoginService
{
	class func loginToTwitter(completion: (String?, ACAccount?) -> ())
	{
		let accountStore = ACAccountStore()
		let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
		accountStore.requestAccessToAccountsWithType(accountType, options: nil)
			{ (success, error) -> Void in
				if let _ = error
				{
					completion("ERROR: failed to access accounts", nil)
				}
				else if success
				{
					if let account = accountStore.accountsWithAccountType(accountType).first as? ACAccount
					{
						//there's an account
						completion(nil, account)
					}
				}
		}
	}
}