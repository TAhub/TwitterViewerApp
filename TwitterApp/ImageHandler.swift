//
//  ImageHandler.swift
//  TwitterApp
//
//  Created by Theodore Abshire on 10/29/15.
//  Copyright © 2015 Theodore Abshire. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler
{
	static let sharedService = ImageHandler()
	
	//the image cache
	var imageCache = [String : UIImage]()
	
	class func fetchImage(urlString:String, completion: (String?, UIImage?) -> ())
	{
		//because of the cache, this function may or may not be asnchronous
		//therefore, dispatching back to the main queue is handled in here, if appropriate
		
		if let cachedImage = sharedService.imageCache[urlString]
		{
			completion(nil, cachedImage)
		}
		else if let url = NSURL(string: urlString)
		{
			let queue = dispatch_queue_create("image_dispatch_queue", nil)
			dispatch_async(queue)
				{
					let imageData = NSData(contentsOfURL: url)
					
					dispatch_async(dispatch_get_main_queue())
						{
							if let imageData = imageData
							{
								let image = UIImage(data: imageData)
								completion(nil, image)
								sharedService.imageCache[urlString] = image
							}
							else
							{
								completion("ERROR: failed to retrieve image at \(urlString)", nil)
							}
					}
			}
		}
	}
}