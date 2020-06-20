//
//  ImageViewModel.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation
import UIKit

final class ImageViewModel: NSObject {
    
    var arrPhotos: KxSwift<[Photo?]> = KxSwift<[Photo?]>([])
    let imageService: ImageService = ImageService()
    
    let downloadService = DownloadService()
    var onReload: ((_ index: Int, _ isDownloadingCompleted: Bool) -> Void)?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "com.raywenderlich.HalfTunes.bgSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    override init() {
        super.init()
        downloadService.downloadsSession = downloadsSession
    }
    
    func getImage() {
        
        imageService.fetchImages(key: "") {[weak self] (imageModel, error) in
            
            guard let `self` = self,
                let imgModel = imageModel,
                let photos = imgModel.photos,
                let photo = photos.photo
                else {
                    return
            }
            
            self.arrPhotos.value = photo
        }
    }
    
}
// MARK: - Search Photos -
extension ImageViewModel {
    
    func searchPhoto(search: String? = nil) {
        
        guard let searchtext = search,
            !searchtext.isEmpty else {
            return
        }
        
        let fillter = arrPhotos.value.filter { (photo) -> Bool in
            return (photo?.title?.contains("") ?? false)
        }
    }
}

// MARK: - URL Session Download Delegate -
extension ImageViewModel: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        // 1
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let download = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        do {
            let data:Data! = try? Data(contentsOf: location)
            if let image = UIImage(data: data) {
                CahceImage.shared.storeImageToCache(sourceURL.absoluteString as AnyObject, image)
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self,
                        let index = download?.index else {
                            return
                    }
                    self.onReload?(index, true)
                }
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        // 1
        guard
            let url = downloadTask.originalRequest?.url,
            let download = downloadService.activeDownloads[url]  else {
                return
        }
        
        DispatchQueue.main.async {
            guard let index = download.index else {
                return
            }
            self.onReload?(index, false)
            
        }
    }
}
