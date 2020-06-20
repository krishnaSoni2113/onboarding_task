//
//  ImageCollectionView.swift
//  onboarding_task
//
//  Created by Krishna Soni on 19/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionView: UICollectionView {
    
    private let imageViewModel: ImageViewModel = ImageViewModel()
    private var arrPhoto: [Photo?] = []
    var didSearch: ((_ text: String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
        configureObserver()
        configureImageViewModel()
    }
    
    func configureCollectionView() {
        self.delegate = self
        self.dataSource = self
        self.register(UINib(nibName: "ImageColCell", bundle: nil), forCellWithReuseIdentifier: "ImageColCell")
        self.reloadData()
    }
}

extension ImageCollectionView {
    
    func configureObserver() {
        
        imageViewModel.arrPhotos.subscribe { [weak self] (result) in
            
            guard let `self` = self else{
                return
            }
            
            self.arrPhoto = result
            self.reloadData()
        }
        
        imageViewModel.onReload = {[weak self] (index: Int, isDownloadingCompleted: Bool) in
            guard let `self` = self else{
                return
            }
            
            if isDownloadingCompleted {
                self.reloadItems(at: [IndexPath(item: index, section: 0)])
            } else {
                if let cell = self.cellForItem(at: IndexPath(row: index, section: 0)) as? ImageColCell {
                    cell.btnDownload.isHidden = true
                    cell.btnCancel.isHidden = false
                }
            }
        }
        
        didSearch = { [weak self] (search) in
            guard let `self` = self else{
                return
            }
            
            guard let searchtext = search,
                !searchtext.isEmpty else {
                    self.arrPhoto = self.imageViewModel.arrPhotos.value
                    self.reloadData()
                    return
            }
            
            self.arrPhoto = self.imageViewModel.arrPhotos.value.filter { (photo) -> Bool in
                return (photo?.title?.contains(searchtext) ?? false)
            }
            
            self.reloadData()
        }
        
    }
    
    private func configureImageViewModel() {
        imageViewModel.getImage()
    }
}


// MARK:- UICollectionView Delegate/Datasources -
extension ImageCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPhoto.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CScreenWidth/2
        return CGSize(
            width:cellSize,
            height: cellSize
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageColCell", for: indexPath) as? ImageColCell,
            let photo = arrPhoto[indexPath.row] else {
                return UICollectionViewCell()
        }
        
        let download = imageViewModel.downloadService.activeDownloads[photo.imageURL]
        cell.configureImageColCell(photo: photo, dowload: download)
        
        cell.onTapDownload = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.imageViewModel.downloadService.startDownload(photo, indexPath.item)
        }
        
        cell.onTapCancel = { [weak self] in
            guard let `self` = self else {
                return
            }
            self.imageViewModel.downloadService.cancelDownload(photo)
        }
        return cell
    }
}

