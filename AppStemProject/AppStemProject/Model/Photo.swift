//
//  Photo.swift
//  AppStemProject
//
//  Created by Mondale on 4/23/22.
//

import UIKit

struct PhotoList: Codable {
    var results: [Photo]
}

struct Photo: Codable {
    var urls: PhotoURL
}

struct PhotoURL: Codable {
    var regular: String
}
