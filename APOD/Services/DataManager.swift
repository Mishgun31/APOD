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
        "Pick the date in order to see the photo of that day",
        "Set a range of dates in order to see photos of that period",
        "Set a number of random photos"
    ]
    
    private init() {}
    
    func getSettingsLabelTexts() -> [String] {
        settingsLabelTexts
    }
}
    
// MARK: - Work with UserDefaults

extension DataManager {
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
    
    func saveStateOfSettingsPage(for object: SettingsState) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        UserDefaults.standard.set(data, forKey: "settingsState")
    }
    
    func loadStateOfSettingsPage() -> SettingsState {
        guard let data = UserDefaults.standard.object(forKey: "settingsState")
                as? Data else { return SettingsState()}
        guard let settingsState = try? JSONDecoder().decode(SettingsState.self, from: data) else {
            return SettingsState()
        }
        return settingsState
    }
}

// MARK: - Text description enum

enum TextDescription: String {
    case help = "There will be some description text here one"
    case appInfo = "There will be some description text here two"
    case dateRangeWarning = """
    The starting date mustn't be earlier than June 16, 1995.
    """
    case randomPicturesWarning = "The number must be from 1 to 50"
}
