//
//  ExpandedStateView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/07.
//

import UIKit

import Then
import SnapKit

class ExpandedStateView: UIView {
    // MARK: - Properties
    lazy var listTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(ExpandedDayTVC.self, forCellReuseIdentifier: ExpandedDayTVC.identifier)
        $0.register(ExpandedWeekTVC.self, forCellReuseIdentifier: ExpandedWeekTVC.identifier)
    }
    lazy var bottomView = SelectedStrokeView().then {
        $0.backgroundColor = .white
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .systemGray
    }
    
    let days: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    let weeks: [String] = ["WEEK1", "WEEK2", "WEEK3", "WEEK4", "WEEK5"]
        
    var state: CurrentState?
    private var isModified = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupModifyButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setupLayout() {
        addSubviews([titleLabel, listTableView, bottomView])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(34)
            $0.centerX.equalToSuperview()
        }
        
        listTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(36)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.hasNotch ? 93 : 49)
        }
    }
    
    private func setupModifyButton() {
        bottomView.selectButton.addTarget(self, action: #selector(touchUpModify), for: .touchUpInside)
    }
    
    // MARK: - @objc
    @objc
    private func touchUpModify() {
        isModified.toggle()
        listTableView.reloadSections(IndexSet(0...0), with: .fade)
        
        bottomView.selectButton.setTitle(isModified ? "수정한 영법 저장하기" : "영법 수정하기", for: .normal)
    }
}

// MARK: - UITableViewDataSource
extension ExpandedStateView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .day,
             .base:
            return 10
        case .week:
            return 7
        case .month:
            return 5
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch state {
        case .day,
             .base:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDayTVC.identifier) as? ExpandedDayTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.changeCellConfiguration(isModified)
            return cell
        case .week:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedWeekTVC.identifier) as? ExpandedWeekTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.dayLabel.text = days[indexPath.row]
            return cell
        case .month:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedWeekTVC.identifier) as? ExpandedWeekTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.dayLabel.text = weeks[indexPath.row]
            return cell
        case .routine:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDayTVC.identifier) as? ExpandedDayTVC else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension ExpandedStateView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch state {
        case .routine:
            return 0
        default:
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .white
        tableView.separatorInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch state {
        case .day,
             .base:
            let header = DayHeader()
            header.backgroundColor = .white
            return header
        case .week:
            let header = WeekMonthHeader()
            header.backgroundColor = .white
            header.dateTitle.text = "요일"
            return header
        case .month:
            let header = WeekMonthHeader()
            header.backgroundColor = .white
            header.dateTitle.text = "주차"
            return header
        default:
            return UIView()
        }
    }
}
