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
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    var request = RequestType.defaultRequest
    private lazy var dateRange = (firstDatePicker.date, lastDatePicker.date)
    
    private var settingsState = DataManager.shared.loadStateOfSettingsPage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStartingScreenState()
        segmentedControlAction()
    }
}
    
// MARK: - IBActions

extension SettingsViewController {
    
    @IBAction func helpButtonPressed(_ sender: UIBarButtonItem) {
        showAlert(withTitle: "Help", andMessage: TextDescription.help.rawValue)
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
        
        settingsState.segmentedControlIndex = segmentedControl.selectedSegmentIndex
    }
    
    @IBAction func singleDatePickerAction() {
        let stringDate = formatDate(from: singleDatePicker.date)
        request = .chosenDateRequest(date: stringDate)
    }
    
    @IBAction func rangedDatePickerAction(_ sender: UIDatePicker) {
        if sender == firstDatePicker {
            dateRange.0 = sender.date
        } else {
            dateRange.1 = sender.date
        }
        
        let stringFirstDate = formatDate(from: dateRange.0)
        let stringSecondDate = formatDate(from: dateRange.1)
        request = .rangeDatesRequest(startDate: stringFirstDate,
                                     endDate: stringSecondDate)
    }
    
    @IBAction func stepperAction() {
        if numberTextField.text == "" {
            stepper.value = 1
        }
        numberTextField.text = String(format: "%.f", stepper.value)
        request = .randomObjectsRequest(numberOfObjects: Int(stepper.value))
    }
    
    @IBAction func saveButtonPressed() {
        if segmentedControl.selectedSegmentIndex == 1,
           firstDatePicker.date >= lastDatePicker.date {
            showAlert(withTitle: "Warning",
                      andMessage: TextDescription.dateRangeWarning.rawValue)
            return
        }
        
        saveValuesOfUIElements()
        performSegue(withIdentifier: "unwind", sender: self)
    }
}

// MARK: - Private methods

extension SettingsViewController {
    
    private func setupUI() {
        for stackView in stackViewCollection {
            stackView.isHidden = true
        }
        
        let labelTexts = DataManager.shared.getSettingsLabelTexts()
        
        if segmentedControl.selectedSegmentIndex <= labelTexts.count - 1 {
            descriptionLabel.text = labelTexts[segmentedControl.selectedSegmentIndex]
        }
        
        if segmentedControl.selectedSegmentIndex <= stackViewCollection.count - 1 {
            stackViewCollection[segmentedControl.selectedSegmentIndex].isHidden = false
        }
        
        numberTextField.text = String(format: "%.f", stepper.value)
    }
    
    private func loadStartingScreenState() {
        setDateRestriction(for: singleDatePicker)
        setDateRestriction(for: firstDatePicker)
        setDateRestriction(for: lastDatePicker)
        
        numberTextField.delegate = self
        addGestureRecognizer()
        numberTextField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        setInitialValuesForUIElements()
    }
    
    private func setDateRestriction(for datePicker: UIDatePicker) {
        // The server is located in the USA and the new photo of the day is
        // available in US time zone
        
        let californiaTimeZone = TimeZone(identifier: "America/Los_Angeles")
        
        let minimumDateComponents = DateComponents(year: 1995, month: 6, day: 16)
        let minimumDate = Calendar.current.date(from: minimumDateComponents)
        
        datePicker.timeZone = californiaTimeZone
        datePicker.minimumDate = minimumDate
        datePicker.maximumDate = datePicker.date
    }
    
    private func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        segmentedControl.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setInitialValuesForUIElements() {
        segmentedControl.selectedSegmentIndex = settingsState.segmentedControlIndex
        
        switch settingsState.segmentedControlIndex {
        case 0:
            singleDatePicker.date = settingsState.singleDate ?? singleDatePicker.date
        case 1:
            firstDatePicker.date = settingsState.rangeFirstDate ?? firstDatePicker.date
            lastDatePicker.date = settingsState.rangeLastDate ?? lastDatePicker.date
        default:
            stepper.value = settingsState.numberOfRandomPictures ?? stepper.value
        }
    }
    
    private func saveValuesOfUIElements() {
        settingsState = SettingsState()
        settingsState.segmentedControlIndex = segmentedControl.selectedSegmentIndex
        
        switch settingsState.segmentedControlIndex {
        case 0:
            settingsState.singleDate = singleDatePicker.date
        case 1:
            settingsState.rangeFirstDate = firstDatePicker.date
            settingsState.rangeLastDate = lastDatePicker.date
        default:
            settingsState.numberOfRandomPictures = stepper.value
        }
        
        DataManager.shared.saveStateOfSettingsPage(for: settingsState)
    }
}

// MARK: - UITextFieldDelegate, Working with keyboard

extension SettingsViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange() {
        guard let valueFromText = Double(numberTextField.text ?? "") else {
            stepper.value = 1
            return
        }
        stepper.value = valueFromText
        
        if valueFromText == 0 {
            showAlert(withTitle: "Warning",
                      andMessage: TextDescription.randomPicturesWarning.rawValue)
            numberTextField.text = "1"
        } else if valueFromText > 50 {
            showAlert(withTitle: "Warning",
                      andMessage: TextDescription.randomPicturesWarning.rawValue)
            numberTextField.text = "50"
        }
    }

    @objc private func hideKeyboard() {
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
            showAlert(withTitle: "Warning",
                      andMessage: TextDescription.randomPicturesWarning.rawValue)
            textField.text = "1"
        }
        request = .randomObjectsRequest(numberOfObjects: Int(stepper.value))
    }
}
