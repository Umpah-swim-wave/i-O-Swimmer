//
//  SelectedRangeVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/27.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SelectedRangeVC: BaseViewController {
    
    // MARK: - properties

    private var backgroundView = UIButton().then {
        $0.backgroundColor = .black.withAlphaComponent(0.6)
        $0.addTarget(self, action: #selector(dismissWhenTappedBackView), for: .touchUpInside)
    }
    private lazy var rangeView = RangeView().then {
        $0.rootVC = self
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .white
    }

    var rangeState: RangeState = .none
    var dayData: ((String, String, String) -> ())?
    var weekData: ((String) -> ())?
    var monthData: ((String, String) -> ())?
    var year: String = ""
    var month: String = ""
    var day: String = ""
    var week: String = ""
    var years: [String] = ["2022", "2021","2020","2019","2018","2017","2016","2015","2014","2013","2012","2011","2010"]
    var months: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    var days: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    var weeks: [String] = ["이번주", "지난주", "10/18 ~ 10/24", "9/6 ~ 9/12", "8/30 ~ 8/5"]
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    override func configUI() {
        view.backgroundColor = .clear.withAlphaComponent(0)
    }
    
    override func render() {
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
    
    // MARK: - func
    
    private func bind() {
        rangeView.dayButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.setupSelectedRangeState(daySelected: true)
                self.setupRangeData(year: self.years[0], month: self.months[0], day: self.days[0], rangeState: .day)
                self.view.endEditing(true)
                self.rangeView.setupPickerViewToTextField(with: .day)
            })
            .disposed(by: disposeBag)
        
        rangeView.weekButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.setupSelectedRangeState(weekSelected: true)
                self.setupRangeData(week: self.weeks[0], rangeState: .week)
                self.view.endEditing(true)
                self.rangeView.setupPickerViewToTextField(with: .week)
            })
            .disposed(by: disposeBag)
        
        rangeView.monthButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.setupSelectedRangeState(monthSelected: true)
                self.setupRangeData(year: self.years[0], month: self.months[0], rangeState: .month)
                self.view.endEditing(true)
                self.rangeView.setupPickerViewToTextField(with: .month)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSelectedRangeState(daySelected: Bool = false,
                                         weekSelected: Bool = false,
                                         monthSelected: Bool = false) {
        rangeView.dayButton.isSelected = daySelected
        rangeView.weekButton.isSelected = weekSelected
        rangeView.monthButton.isSelected = monthSelected
    }
    
    private func setupRangeData(year: String = "",
                                month: String = "",
                                day: String = "",
                                week: String = "",
                                rangeState: RangeState) {
        self.year = year
        self.month = month
        self.day = day
        self.week = week
        self.rangeState = rangeState
    }
    
    func sendDateDataToParentViewController() {
        switch rangeState {
        case .day:
            dayData?(year, month, day)
        case .week:
            weekData?(week)
        case .month:
            monthData?(year, month)
        case .none:
            break
        }
    }
}
