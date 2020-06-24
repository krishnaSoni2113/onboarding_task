//
//  Networking.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation

// This class will hold all the HTTPs Methods (POST/GET/PUT/DELETE)
final class Networking {
    
    typealias ClosureSuccess = (_ task:URLSessionTask, _ response:AnyObject?, _ statusCode: Int, _ data: Data?) -> Void
    typealias ClosureError   = (_ task:URLSessionTask, _ error:NSError?) -> Void
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    /// Networking Singleton
    static let sharedInstance = Networking()
    
    // HTTPs Methods
    @discardableResult
    func GET(param parameters:[String: Any]?, tag:String?, success:ClosureSuccess?,  failure:ClosureError?) -> URLSessionTask? {
        
        let session = URLSession.shared
        var dataTask: URLSessionDataTask?
        
        let url = URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=8a9cbbf8d3a666a74f20801f3c3ff05a&format=json&nojsoncallback=1&api_sig=5ce53d0304b865f2a6e947dc0bd4a50d")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        dataTask =
            session.dataTask(with: request) { [weak self] data, response, error in
                
                guard let _ = self else {
                    return
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    DispatchQueue.main.async {
                        success!(dataTask!, response as AnyObject, response.statusCode, data)
                    }
                }
        }
        dataTask!.resume()
        return dataTask
    }
}
