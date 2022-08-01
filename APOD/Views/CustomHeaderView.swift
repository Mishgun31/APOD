//
//  CustomHeaderView.swift
//  APOD
//
//  Created by Михаил Мезенцев on 03.06.2022.
//

import UIKit

class CustomHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    func configure(with title: String) {
        labelView.text = title
        activityIndicatorView.hidesWhenStopped = true
        checkIfShouldAnimateSpinner()
    }
    
    private func checkIfShouldAnimateSpinner() {
        if let _ = DataManager.shared.loadPictures() {
            return
        } else {
            activityIndicatorView.startAnimating()
        }
    }
}
