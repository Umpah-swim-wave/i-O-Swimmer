//
//  RangeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import Then
import SnapKit

class RangeView: UIView {
    
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
    let titleLabel = UILabel().then {
        $0.text = "기간 선택"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 18)
    }
    let infoLabel = UILabel().then {
        $0.text = "기본값은 가장 최근 기록입니다!"
        $0.textColor = .upuhWarning
        $0.font = .IBMPlexSansRegular(ofSize: 11)
    }
    let buttonStackView = UIStackView().then {
        $0.alignment = .center
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    let dayButton = RangeButton(title: "일간")
    let weekButton = RangeButton(title: "주간")
    let monthButton = RangeButton(title: "월간")
    let dayTextField = UITextField()
    let weekTextField = UITextField()
    let monthTextField = UITextField()
    
    weak var rootVC: SelectedRangeVC?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubviews([titleLabel, buttonStackView, infoLabel])
        addSubviews([dayTextField, weekTextField, monthTextField])
        buttonStackView.addArrangedSubview(dayButton)
        buttonStackView.addArrangedSubview(weekButton)
        buttonStackView.addArrangedSubview(monthButton)
        
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
extension RangeView: UIPickerViewDataSource {
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
            return rootVC.weeks.count
        default:
            guard let componentType = DateComponent(rawValue: component) else { return 0 }
            switch componentType {
            case .year:
                return rootVC.years.count
            case .month:
                return rootVC.months.count
            case .day:
                return rootVC.days.count
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension RangeView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let rootVC = rootVC else { return "" }
        switch rootVC.rangeState {
        case .week:
            return rootVC.weeks[row]
        default:
            guard let componentType = DateComponent(rawValue: component) else { return "" }
            switch componentType {
            case .year:
                return rootVC.years[row]
            case .month:
                return rootVC.months[row]
            case .day:
                return rootVC.days[row]
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
                rootVC.year = rootVC.years[row]
            case .month:
                rootVC.month = rootVC.months[row]
            case .day:
                rootVC.day = rootVC.days[row]
            }
        case .week:
            rootVC.week = rootVC.weeks[row]
        case .month:
            guard let componentType = DateComponent(rawValue: component) else { return }
            switch componentType {
            case .year:
                rootVC.year = rootVC.years[row]
            case .month:
                rootVC.month = rootVC.months[row]
            default:
                break
            }
        case .none:
            break
        }
    }
}
