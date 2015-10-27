//: Playground - noun: a place where people can play

import UIKit

//Day 1: reverse an array

//this reverses an arbitrary array
func reverseArray<T>(array:[T]) -> [T]
{
	//unless my source is out of date,
	//insert takes O(n) time, while append takes UP TO O(n) time, but much lower most of the time
	//so it's more efficient to iterate over the array backwards and append, then forward and insert
	//sorry it's not very pretty!
	var revArray = [T]()
	for i in 0..<array.count
	{
		revArray.append(array[array.count - i - 1])
	}
	return revArray
}


//example
let sampleArray:[String] = ["ONE", "TWO", "THREE"]
let reversedArray = reverseArray(sampleArray)
let sampleArrayTwo:[Int] = [1, 2, 3, 4, 5]
let reversedArrayTwo = reverseArray(sampleArrayTwo)