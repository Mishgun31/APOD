//
//  SettingsViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 17.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    private var singleDate: Date?
    private var dateRange: [Date]?
    private var randomNumber: Int?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var stackViewCollection: [UIStackView]!
    
    @IBOutlet weak var singleDatePicker: UIDatePicker!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setDateRestriction(for: singleDatePicker)
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
    
    @IBAction func saveButtonPressed() {
    }
    
    @IBAction func singleDatePickerAction() {
       
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
    
    private func setDateRestriction(for datePicker: UIDatePicker) {
        let minimumDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        let minimumDate = Calendar.current.date(from: minimumDateComponents)
        
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = Date()
    }
}
