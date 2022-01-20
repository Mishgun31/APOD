//
//  DataManager.swift
//  APOD
//
//  Created by Михаил Мезенцев on 19.01.2022.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private let texts: [TextDescription: [String]] = [
        .settingsLabel: [
            "There will be some text for Label One here",
            "There will be some text for Label Two here",
            "There will be some text for Label Three here"
        ],
        .help: [
            "There will be some description text here"
        ],
        .appInfo: [
            "There will be some description text here"
        ]
    ]
    
    private init() {}
    
    func getTextData(for key: TextDescription) -> [String] {
        texts[key] ?? []
    }
}

// MARK: - Text description enum

enum TextDescription {
    case settingsLabel
    case help
    case appInfo
}
