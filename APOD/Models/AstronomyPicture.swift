//
//  AstronomyPicture.swift
//  APOD
//
//  Created by Михаил Мезенцев on 18.12.2021.
//

import Foundation

struct AstronomyPicture: Codable {
    
    let title: String?
    let date: String?
    let url: String?
    let hdurl: String?
    let medeaType: String?
    let explanation: String?
    let thumbnailUrl: String?
    let copyright: String?
}

struct PictureDimension {
    
    let height: Double
    let width: Double
    
    var aspectRatio: Double {
        height / width
    }
}
