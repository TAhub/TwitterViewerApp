//: Playground - noun: a place where people can play

import UIKit

//Day 2: FizzBuzz

//it prints fizzbuzz ok? there's not much to say about it
func fizzBuzz()
{
	for i in 1...100
	{
		var stringOutput = ""
		if i % 3 == 0
		{
			stringOutput += "Fizz"
		}
		if i % 5 == 0
		{
			stringOutput += "Buzz"
		}
		print(stringOutput.isEmpty ? i : stringOutput)
	}
}

//example
fizzBuzz()