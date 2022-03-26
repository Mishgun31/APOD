//
//  DataManager.swift
//  APOD
//
//  Created by Михаил Мезенцев on 19.01.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private let settingsLabelTexts = [
        "There will be some text for Label One here",
        "There will be some text for Label Two here",
        "There will be some text for Label Three here"
    ]
    
    private init() {}
    
    func getSettingsLabelTexts() -> [String] {
        settingsLabelTexts
    }
}

// MARK: - Text description enum

enum TextDescription: String {
    case help = "There will be some description text here one"
    case appInfo = "There will be some description text here two"
    case dateRangeWarning = "There will be some description text here three"
    case randomPicturesWarning = "There will be some description text here four"
}
