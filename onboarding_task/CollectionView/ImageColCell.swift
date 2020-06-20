//
//  ImageColCell.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import UIKit

class ImageColCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView! {
        didSet {
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.white.cgColor
        }
    }
    
    @IBOutlet weak var btnDownload: UIButton! {
        didSet {
            configureButton(button: btnDownload)
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton! {
        didSet {
            configureButton(button: btnCancel)
        }
    }
    
    private let cahceImage: CahceImage = CahceImage.shared
    
    var onTapDownload: (() -> Void)?
    var onTapCancel: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureButton(button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
}

// MARK:- Configure -
extension ImageColCell {
    
    // Cofigure the cell for photo
    func configureImageColCell(photo: Photo?, dowload: Download?) {
        
        btnCancel.isHidden = true
        btnDownload.isHidden = true
        
        guard let `photo` = photo else {
            return
        }
        
        let imagePath = photo.imageURL.absoluteString
        
        // If image is in cache then load image from cache
        if let image = cahceImage.imageFromCache(imagePath as AnyObject)  {
            imgView.image = image
        } else {
            imgView.image = nil
            if let `download` = dowload, download.isDownloading {
                // show cancel button
                btnCancel.isHidden = false
            }else {
                // Show download button
                btnDownload.isHidden = false
            }
        }
    }
}

// MARK:- Action Events -
extension ImageColCell {
    
    @IBAction func btnDownloadCLK(_ button: UIButton) {
        onTapDownload?()
    }
    
    @IBAction func btnCancelCLK(_ button: UIButton) {
        onTapCancel?()
    }
    
}
