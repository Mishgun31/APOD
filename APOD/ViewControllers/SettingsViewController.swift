//
//  SettingsViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 17.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var request = RequestType.defaultRequest

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var stackViewCollection: [UIStackView]!
    
    @IBOutlet var datePickers: [UIDatePicker]!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDateRestriction(for: datePickers)
    }
    
    // MARK: - IBActions
    
    @IBAction func helpButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlAction() {
        setupUI()
    }
    
    @IBAction func singleDatePickerAction(_ sender: UIDatePicker) {
        let stringDate = formatDate(from: sender.date)
        request = .chosenDateRequest(date: stringDate)
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        for stackView in stackViewCollection {
            stackView.isHidden = true
        }
        
        let labelTexts = DataManager.shared.getTextData(for: .settingsLabel)
        
        if segmentedControl.selectedSegmentIndex <= labelTexts.count - 1 {
            descriptionLabel.text = labelTexts[segmentedControl.selectedSegmentIndex]
        }
        
        if segmentedControl.selectedSegmentIndex <= stackViewCollection.count - 1 {
            stackViewCollection[segmentedControl.selectedSegmentIndex].isHidden = false
        }
    }
    
    private func setDateRestriction(for datePickers: [UIDatePicker]) {
        let minimumDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        let minimumDate = Calendar.current.date(from: minimumDateComponents)
        
        for datePicker in datePickers {
            datePicker.minimumDate = minimumDate
            datePicker.maximumDate = Date()
        }
    }
    
    private func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
    }
}
