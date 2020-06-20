//
//  Download.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation

class Download {
    
    // MARK: - Variables And Properties -
    var isDownloading = false
    var index: Int?
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var photo: Photo
    
    // MARK: - Initialization
    init(photo: Photo) {
        self.photo = photo
    }
}

