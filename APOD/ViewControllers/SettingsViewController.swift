//
//  SettingsViewController.swift
//  APOD
//
//  Created by Михаил Мезенцев on 17.01.2022.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var stackViewCollection: [UIStackView]!
    
    @IBOutlet weak var singleDatePicker: UIDatePicker!
    @IBOutlet weak var firstDatePicker: UIDatePicker!
    @IBOutlet weak var lastDatePicker: UIDatePicker!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var numericalTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    var request = RequestType.defaultRequest
    private var dateRange = (Date(), Date())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        setDateRestriction(for: singleDatePicker)
        setDateRestriction(for: firstDatePicker)
        setDateRestriction(for: lastDatePicker)
        
        segmentedControlAction()
        
        numericalTextField.delegate = self
        addGestureRecognizer()
        numericalTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
    }
    
    // MARK: - IBActions
    
    @IBAction func helpButtonPressed(_ sender: UIBarButtonItem) {
        showAlert(withTitle: "Title", andMessage: "Message")
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func segmentedControlAction() {
        setupUI()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            singleDatePickerAction()
        case 1:
            rangedDatePickerAction(firstDatePicker)
            rangedDatePickerAction(lastDatePicker)
        default:
            stepperAction()
        }
    }
    
    @IBAction func singleDatePickerAction() {
        let stringDate = formatDate(from: singleDatePicker.date)
        request = .chosenDateRequest(date: stringDate)
    }
    
    @IBAction func rangedDatePickerAction(_ sender: UIDatePicker) {
        if sender == firstDatePicker  {
            dateRange.0 = sender.date
        } else {
            dateRange.1 = sender.date
        }
        
        guard dateRange.0 < dateRange.1 else { return }
        
        let stringFirstDate = formatDate(from: dateRange.0)
        let stringSecondDtae = formatDate(from: dateRange.1)
        request = .rangeDatesRequest(startDate: stringFirstDate,
                                     endDate: stringSecondDtae)
    }
    
    @IBAction func stepperAction() {
        if numericalTextField.text == "" {
            stepper.value = 1
        }
        numericalTextField.text = String(format: "%.f", stepper.value)
        request = .randomObjectsRequest(numberOfObjects: Int(stepper.value))
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
        
        numericalTextField.text = String(format: "%.f", stepper.value)
    }
    
    private func setDateRestriction(for datePicker: UIDatePicker) {
        let minimumDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        let minimumDate = Calendar.current.date(from: minimumDateComponents)
        
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = Date()
    }
    
    private func formatDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    private func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        segmentedControl.addGestureRecognizer(tapGestureRecognizer)
    }
}

// MARK: - UITextFieldDelegate, Working with keyboard

extension SettingsViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: 100, height: 100)
        )

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(hideKeyboard)
        )

        let flexButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        keyboardToolbar.items = [flexButton, doneButton]
        keyboardToolbar.sizeToFit()
        textField.inputAccessoryView = keyboardToolbar
    }
        
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            // add calling alert here
            textField.text = "1"
        }
        request = .randomObjectsRequest(numberOfObjects: Int(stepper.value))
    }
    
    @objc private func textFieldDidChange() {
        guard let valueFromText = Double(numericalTextField.text ?? "") else {
            stepper.value = 1
            return
        }
        stepper.value = valueFromText
        
        if valueFromText == 0 {
            // add calling alert here
            numericalTextField.text = "1"
        } else if valueFromText > 50 {
            // add calling alert here
            numericalTextField.text = "50"
        }
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
