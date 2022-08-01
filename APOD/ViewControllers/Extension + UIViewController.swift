//
//  Extension + UIViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 18.02.2022.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let actionButton = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(actionButton)
        present(alert, animated: true)
    }
    
    func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "America/Los_Angeles")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
