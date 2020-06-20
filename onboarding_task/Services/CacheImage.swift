//
//  CacheImage.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation
import UIKit

final class CahceImage {
    
    static let shared = CahceImage()
    
    private let cache: NSCache = NSCache<AnyObject, UIImage>()
    
    // Store image to cache
    func storeImageToCache(_ atPath: AnyObject, _ image: UIImage) {
        cache.setObject(image, forKey: atPath)
    }
    
    // To get the image from cache
    func imageFromCache(_ atPath: AnyObject) -> UIImage? {
        
        guard let image = cache.object(forKey: atPath) else {
            return nil
        }
        
        return image
    }
    
}
