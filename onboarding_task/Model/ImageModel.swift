//
//  ImageModel.swift
//  onboarding_task
//
//  Created by Krishna Soni on 20/06/20.
//  Copyright © 2020 Krishna Soni. All rights reserved.
//

import Foundation

struct ImageModel: Codable {
    let photos: Photos?
}

struct Photos: Codable {
    let page: Int?
    let pages: Int?
    let perpage: Int?
    let total: Int?
    let stat: String?
    let photo: [Photo]?
}

struct Photo: Codable {
    let id: String?
    let owner: String?
    let secret: String?
    let server: String?
    let farm: Int?
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
    
    var imageURL: URL {
//        https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
//        let previewURL = URL(string: "https://farm66.staticflickr.com/65535/50024312503_1b66645b31.jpg")!
        let previewURL = URL(string: "https://farm\(farm ?? 0).staticflickr.com/\(server ?? "")/\(id ?? "")_\(secret ?? "").jpg")!
        return previewURL
    }
}
