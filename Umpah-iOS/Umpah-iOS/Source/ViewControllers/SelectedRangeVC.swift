//
//  SelectedRangeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import Then

class SelectedRangeVC: UIViewController {
    // MARK: - Properties
    var backgroundView = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
        $0.addTarget(self, action: #selector(dismissWhenTappedBackView), for: .touchUpInside)
    }
    let rangeView = RangeView().then {
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }
    
    // MARK: - Lazy Properties
    lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    lazy var datePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .date
        $0.locale = Locale(identifier: "ko-KR")
        $0.timeZone = .autoupdatingCurrent
    }
    
    var secondButtonDataSource = ["White", "Red", "Green", "Blue"];

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupLayout()
    }
    
    private func configUI() {
        view.backgroundColor = .clear.withAlphaComponent(0)
        
        rangeView.dayButton.addTarget(self, action: #selector(didTappedDay), for: .touchUpInside)
        rangeView.weekButton.addTarget(self, action: #selector(didTappedWeek), for: .touchUpInside)
        rangeView.monthButton.addTarget(self, action: #selector(didTappedMonth), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubviews([backgroundView, rangeView])
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rangeView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(195)
        }
    }
    
    private func configureToolBar() -> UIToolbar {
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        return toolbar
    }
    
    // MARK: - @Objc
    @objc
    func didTappedDay() {
        print("day")
        rangeView.dayTextField.inputView = datePicker
        rangeView.dayTextField.inputAccessoryView = configureToolBar()
        rangeView.dayTextField.becomeFirstResponder()
    }
    
    @objc
    func didTappedWeek() {
        print("week")
        rangeView.weekTextField.inputView = pickerView
        rangeView.weekTextField.inputAccessoryView = configureToolBar()
        rangeView.weekTextField.becomeFirstResponder()
    }
    
    @objc
    func didTappedMonth() {
        print("month")
        rangeView.monthTextField.inputView = pickerView
        rangeView.monthTextField.inputAccessoryView = configureToolBar()
        rangeView.monthTextField.becomeFirstResponder()
    }
    
    @objc
    func dismissWhenTappedBackView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func donedatePicker(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelDatePicker(){
        view.endEditing(true)
    }
}

extension SelectedRangeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
}

extension SelectedRangeVC: UIPickerViewDelegate {
    
}
