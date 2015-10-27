//: Playground - noun: a place where people can play

import UIKit

//detect the number of occurences of a substring within a given string
func findInstances(string:String, checkFor:String) -> Int
{
	var instances = 0
	for i in string.startIndex..<string.endIndex
	{
		let rangeEnd = i.advancedBy(checkFor.characters.count - 1, limit: string.endIndex.predecessor())
		let substring = string.substringWithRange(i...rangeEnd)
		if substring == checkFor
		{
			instances += 1
		}
	}
	return instances
}


//example
findInstances("Hi ho, hi ho, I should contain two instances of hi!", checkFor: "hi")
findInstances("hihihihihihihihihihi", checkFor: "hi")
findInstances("This can also handle words other than hi!", checkFor: "words")
findInstances("That's probably unnecessary admittedly. Ah well.", checkFor: ".")