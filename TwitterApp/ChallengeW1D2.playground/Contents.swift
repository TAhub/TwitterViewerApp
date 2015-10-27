//: Playground - noun: a place where people can play

import UIKit

//Day 2: FizzBuzz

//it prints fizzbuzz ok? there's not much to say about it
func fizzBuzz()
{
	for i in 1...100
	{
		//I love the ternary operator, because I love it when things are nice and compact
		let stringOutput = (i % 3 == 0 ? "Fizz" : "") + (i % 5 == 0 ? "Buzz" : "")
		print(stringOutput.isEmpty ? i : stringOutput)
	}
}

//example
fizzBuzz()
