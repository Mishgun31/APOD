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
    
    // MARK: - Work with UserDefaults
    
    func saveSingle(picture: AstronomyPicture?) {
        guard let data = try? JSONEncoder().encode(picture) else { return }
        UserDefaults.standard.set(data, forKey: "picture")
    }
    
    func save(pictures: [AstronomyPicture]?) {
        guard let data = try? JSONEncoder().encode(pictures) else { return }
        UserDefaults.standard.set(data, forKey: "pictures")
    }
    
    func loadPicture() -> AstronomyPicture? {
        guard let data = UserDefaults.standard.object(forKey: "picture")
                as? Data else { return nil}
        guard let astronomyPicture = try? JSONDecoder().decode(AstronomyPicture.self, from: data) else {
            return nil
        }
        return astronomyPicture
    }
    
    func loadPictures() -> [AstronomyPicture]? {
        guard let data = UserDefaults.standard.object(forKey: "pictures")
                as? Data else { return nil}
        guard let astronomyPicture = try? JSONDecoder().decode([AstronomyPicture].self, from: data) else {
            return nil
        }
        return astronomyPicture
    }
}

// MARK: - Text description enum

enum TextDescription: String {
    case help = "There will be some description text here one"
    case appInfo = "There will be some description text here two"
    case dateRangeWarning = "There will be some description text here three"
    case randomPicturesWarning = "There will be some description text here four"
}
