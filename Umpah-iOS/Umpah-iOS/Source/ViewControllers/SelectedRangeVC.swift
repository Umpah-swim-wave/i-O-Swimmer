//
//  SelectedRangeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import Then
import SnapKit

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
    
    var state: RangeState = .none
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var week: String = ""
    var dayData: ((String, String, String) -> ())?
    var weekData: ((String) -> ())?
    var monthData: ((String, String) -> ())?
    
    // MARK: - Lazy Properties
    lazy var pickerView = UIPickerView().then {
        $0.delegate = self
        $0.dataSource = self
    }
    
    var years: [String] = ["2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010"]
    var months: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var days: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var weeks: [String] = ["이번주", "지난주", "10/18 ~ 10/24", "9/6 ~ 9/12", "8/30 ~ 8/5"]

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
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(donedatePicker))
        
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        
        return toolbar
    }
    
    // MARK: - @Objc
    @objc
    func didTappedDay() {
        print("day")
        rangeView.dayButton.isSelected = true
        rangeView.weekButton.isSelected = false
        rangeView.monthButton.isSelected = false
        year = years[0]
        month = months[0]
        day = days[0]
        
        view.endEditing(true)
        state = .day
        rangeView.dayTextField.inputView = pickerView
        rangeView.dayTextField.inputAccessoryView = configureToolBar()
        rangeView.dayTextField.becomeFirstResponder()
    }
    
    @objc
    func didTappedWeek() {
        print("week")
        rangeView.dayButton.isSelected = false
        rangeView.weekButton.isSelected = true
        rangeView.monthButton.isSelected = false
        week = weeks[0]
        
        view.endEditing(true)
        state = .week
        rangeView.weekTextField.inputView = pickerView
        rangeView.weekTextField.inputAccessoryView = configureToolBar()
        rangeView.weekTextField.becomeFirstResponder()
    }
    
    @objc
    func didTappedMonth() {
        print("month")
        rangeView.dayButton.isSelected = false
        rangeView.weekButton.isSelected = false
        rangeView.monthButton.isSelected = true
        year = years[0]
        month = months[0]
        
        view.endEditing(true)
        state = .month
        rangeView.monthTextField.inputView = pickerView
        rangeView.monthTextField.inputAccessoryView = configureToolBar()
        rangeView.monthTextField.becomeFirstResponder()
    }
    
    @objc
    func donedatePicker(){
        switch state {
        case .day:
            dayData?(year, month, day)
        case .week:
            weekData?(week)
        case .month:
            monthData?(year, month)
        case .none:
            break
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func cancelDatePicker(){
        rangeView.dayButton.isSelected = false
        rangeView.weekButton.isSelected = false
        rangeView.monthButton.isSelected = false
        view.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource
extension SelectedRangeVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch state {
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
        switch state {
        case .week:
            return weeks.count
        default:
            switch component {
            case 0:
                return years.count
            case 1:
                return months.count
            case 2:
                return days.count
            default:
                return 0
            }
        }
    }
}

// MARK: - UIPickerViewDelegate
extension SelectedRangeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch state {
        case .week:
            return weeks[row]
        default:
            switch component {
            case 0:
                return years[row]
            case 1:
                return months[row]
            case 2:
                return days[row]
            default:
                return ""
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch state {
        case .day:
            switch component {
            case 0:
                year = years[row]
            case 1:
                month = months[row]
            default:
                day = days[row]
            }
        case .week:
            week = weeks[row]
        case .month:
            switch component {
            case 0:
                year = years[row]
            default:
                month = months[row]
            }
        case .none:
            break
        }
    }
}
