//
//  ImageService.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation
import UIKit

class ImageService {
    
    func fetchImages(key: String, handler: @escaping ((ImageModel?, Error?) -> ())) {
        
        //           MILoader.shared.showLoader(type: .activityIndicatorWithMessage, message: nil)
        
        _ = Networking.sharedInstance.GET(param: nil, tag: "cms", success: {[weak self] (sessionTask, response, code, data) in
            
            do {
                if let `data` = data {
                    let imgModel = try JSONDecoder().decode(ImageModel.self, from: data)
                    
                    guard let photos = imgModel.photos else {
                        handler(nil, nil)
                        return
                    }
                    
                    handler(imgModel, nil)
                }
                
            } catch let error {
                handler(nil, error)
            }
            
        }) { (sessionTask, error) in
            handler(nil, error)
            print(error ?? NSError().localizedDescription)
        }
    }
    
    func dowonloadImage(url: String, handler: @escaping ((UIImage?, Error?) -> ())) {
     
//        Networking.sharedInstance.DOWNLOAD(mediaUrl: url, success: {[weak self] (sessionTask, response, code, data) in
//
//            guard let _ = self,
//            let image = response as? UIImage else {
//                return
//            }
//
//            handler(image, nil)
//        }) { (task, error) in
//
//        }
    }
}
