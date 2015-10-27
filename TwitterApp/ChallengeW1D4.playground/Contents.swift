//: Playground - noun: a place where people can play

import UIKit

//Day 4: NoX

//pretty self-explanatory; removes all occurences of "x" except at the start and end
func removeX(string:String) -> String
{
	var newString = ""
	for i in string.startIndex..<string.endIndex
	{
		if string[i] != "x" || i == string.startIndex || i == string.endIndex.predecessor()
		{
			newString.append(string[i])
		}
	}
	return newString
}

//example
removeX("xooooooxh")
removeX("capital X isn't removed, because the requirements didn't explicitly say so")
removeX("xxxxxxx")
