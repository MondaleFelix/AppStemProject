//
//  Photo.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

struct PhotoList: Codable {
    var photos: [Photo]
}

struct Photo: Codable {
    var src: PhotoURL
}

struct PhotoURL: Codable {
    var original: String
}
