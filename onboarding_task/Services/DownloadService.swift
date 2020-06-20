//
//  DownloadService.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation

class DownloadService {
    
    // MARK: - Variables And Properties -
    var activeDownloads: [URL: Download] = [ : ]
    var downloadsSession: URLSession!
    
    
    // MARK: - Internal Methods -
    
    // Cancel downloading
    func cancelDownload(_ photo: Photo) {
        guard let download = activeDownloads[photo.imageURL] else {
            return
        }
        download.task?.cancel()
        
        activeDownloads[photo.imageURL] = nil
    }
    
    // Pause downloading
    func pauseDownload(_ photo: Photo) {
        guard
            let download = activeDownloads[photo.imageURL],
            download.isDownloading
            else {
                return
        }
        
        download.task?.cancel(byProducingResumeData: { data in
            download.resumeData = data
        })
        
        download.isDownloading = false
    }
    
    // resume downloading
    func resumeDownload(_ photo: Photo) {
        guard let download = activeDownloads[photo.imageURL] else {
            return
        }
        
        if let resumeData = download.resumeData {
            download.task = downloadsSession.downloadTask(withResumeData: resumeData)
        } else {
            
            download.task = downloadsSession.downloadTask(with: download.photo.imageURL)
        }
        
        download.task?.resume()
        download.isDownloading = true
    }
    
    // Start downloading
    func startDownload(_ photo: Photo, _ index: Int) {
        
        let download = Download(photo: photo)
        download.task = downloadsSession.downloadTask(with: photo.imageURL)
        download.task?.resume()
        download.isDownloading = true
        download.index = index
        activeDownloads[download.photo.imageURL] = download
    }
}
