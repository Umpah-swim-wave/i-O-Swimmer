//
//  SelectedRangeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import SnapKit
import Then

final class SelectedRangeView: BaseView {
    
    private enum DateComponent: Int, CaseIterable {
        case year
        case month
        case day
    }
    
    // MARK: - Properties
    
    private lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    private let titleLabel = UILabel().then {
        $0.text = "기간 선택"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 18)
    }
    private let infoLabel = UILabel().then {
        $0.text = "기본값은 가장 최근 기록입니다!"
        $0.textColor = .upuhWarning
        $0.font = .IBMPlexSansRegular(ofSize: 11)
    }
    private let buttonStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    private let dayTextField = UITextField()
    private let weekTextField = UITextField()
    private let monthTextField = UITextField()
    let dayButton = RangeButton(title: "일간")
    let weekButton = RangeButton(title: "주간")
    let monthButton = RangeButton(title: "월간")
    
    weak var rootVC: SelectedRangeVC?

    override func render() {
        addSubviews([titleLabel, buttonStackView, infoLabel, dayTextField, weekTextField, monthTextField])
        buttonStackView.addArrangedSubviews([dayButton, weekButton, monthButton])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        buttonStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
        }
        infoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20)
        }
    }
    
    private func configureToolBar() -> UIToolbar {
        let toolbar = UIToolbar();
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(touchUpCancelButton))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(touchUpDoneButton))
        toolbar.sizeToFit()
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        return toolbar
    }
    
    func setupPickerViewToTextField(with rangeState: RangeState) {
        switch rangeState {
        case .day:
            dayTextField.inputView = pickerView
            dayTextField.inputAccessoryView = configureToolBar()
            dayTextField.becomeFirstResponder()
        case .week:
            weekTextField.inputView = pickerView
            weekTextField.inputAccessoryView = configureToolBar()
            weekTextField.becomeFirstResponder()
        case .month:
            monthTextField.inputView = pickerView
            monthTextField.inputAccessoryView = configureToolBar()
            monthTextField.becomeFirstResponder()
        case .none:
            break
        }
    }
    
    @objc
    private func touchUpCancelButton(){
        dayButton.isSelected = false
        weekButton.isSelected = false
        monthButton.isSelected = false
        rootVC?.view.endEditing(true)
    }
    
    @objc
    private func touchUpDoneButton() {
        rootVC?.sendDateDataToParentViewController()
        rootVC?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPickerViewDataSource
extension SelectedRangeView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let rootVC = rootVC else { return 0 }
        switch rootVC.rangeState {
        case .day:
            return 3
        case .week:
            return 1
        case .month:
            return 2
        case .none:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let rootVC = rootVC else { return 0 }
        switch rootVC.rangeState {
        case .week:
            return rootVC.dummyWeeks.count
        default:
            guard let componentType = DateComponent(rawValue: component) else { return 0 }
            switch componentType {
            case .year:
                return rootVC.dummyYears.count
            case .month:
                return rootVC.dummyMonths.count
            case .day:
                return rootVC.dummyDays.count
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension SelectedRangeView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let rootVC = rootVC else { return "" }
        switch rootVC.rangeState {
        case .week:
            return rootVC.dummyWeeks[row]
        default:
            guard let componentType = DateComponent(rawValue: component) else { return "" }
            switch componentType {
            case .year:
                return rootVC.dummyYears[row]
            case .month:
                return rootVC.dummyMonths[row]
            case .day:
                return rootVC.dummyDays[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let rootVC = rootVC else { return }
        switch rootVC.rangeState {
        case .day:
            guard let componentType = DateComponent(rawValue: component) else { return }
            switch componentType {
            case .year:
                rootVC.selectedYear = rootVC.dummyYears[row]
            case .month:
                rootVC.selectedMonth = rootVC.dummyMonths[row]
            case .day:
                rootVC.selectedDay = rootVC.dummyDays[row]
            }
        case .week:
            rootVC.selectedWeek = rootVC.dummyWeeks[row]
        case .month:
            guard let componentType = DateComponent(rawValue: component) else { return }
            switch componentType {
            case .year:
                rootVC.selectedYear = rootVC.dummyYears[row]
            case .month:
                rootVC.selectedMonth = rootVC.dummyMonths[row]
            default:
                break
            }
        case .none:
            break
        }
    }
}
