//
//  SettingsState.swift
//  APOD
//
//  Created by Михаил Мезенцев on 31.05.2022.
//

import Foundation

struct SettingsState: Codable {
    var segmentedControlIndex = 0
    var singleDate: Date?
    var rangeFirstDate: Date?
    var rangeLastDate: Date?
    var numberOfRandomPictures: Double?
}
