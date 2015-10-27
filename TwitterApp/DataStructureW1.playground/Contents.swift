//: Playground - noun: a place where people can play

import UIKit

//Data structure for week 1: a custom queue!

//I considered basing this queue off an array, but that felt like cheating
//instead, it's based on a custom singly-linked list

//so here's the node structure (it's a class so that you can store references to it)
//and it's private because you shouldn't be able to look at the inside structure of a queue
private class Node<T>
{
	private var contents:T
	private var next:Node<T>?
	init(contents:T) { self.contents = contents }
}

//and here's the queue structure
public struct Queue<T>
{
	private var headNode:Node<T>?
	private weak var tailNode:Node<T>?
	
	//count is implemented as a variable instead of a function because finding the count manually is O(n)
	private var _count:Int = 0
	public var count:Int
	{
		return _count
	}
	
	public mutating func enqueue(newElement:T)
	{
		let newNode = Node<T>(contents: newElement)
		if headNode == nil
		{
			//if the head node is nil, the tail is by necessity also nil (since I made it weak and all)
			//so there's no need to check if it's nil or not
			headNode = newNode
			tailNode = newNode
		}
		else
		{
			tailNode?.next = newNode
			tailNode = newNode
		}
		_count += 1
	}
	
	public mutating func dequeue() -> T?
	{
		//a special empty case so the count doesn't go into the negative, etc
		if isEmpty
		{
			return nil
		}
		
		let headContents = head
		headNode = headNode?.next
		_count -= 1
		return headContents
	}
	
	public var head: T?
	{
		return headNode?.contents
	}
	
	public var isEmpty: Bool
	{
		//you could also check if count is 0
		return headNode == nil
	}
}


//example

//queue some stuff
var queue = Queue<Int>()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
queue.enqueue(4)
queue.enqueue(5)

//peek at the head of the queue
queue.head

//get some info
queue.isEmpty
queue.count

//remove some elements
queue.dequeue()
queue.dequeue()
queue.isEmpty
queue.count

//remove some more elements
queue.dequeue()
queue.dequeue()
queue.dequeue()
queue.dequeue()

//oops, we removed too many elements
queue.head
queue.isEmpty
queue.count
