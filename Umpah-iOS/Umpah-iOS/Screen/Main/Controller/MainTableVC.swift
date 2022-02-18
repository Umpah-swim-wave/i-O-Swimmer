//
//  MainTableVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/09.
//

import UIKit

import Charts
import Then

class MainTableVC: MainCardVC {
    
    enum TotalSection: Int, CaseIterable {
        case topHeader
        case content
    }
    
    enum DayBaseRowType: Int, CaseIterable {
        case filter
        case date
        case detail
        case stroke
        case footer
    }
    
    enum WeekMonthRowType: Int, CaseIterable {
        case filter
        case date
        case chart
        case detail
        case footer
    }
    
    // MARK: - properties
    
    lazy var baseTableView = UITableView().then {
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 100
        $0.showsVerticalScrollIndicator = false
        $0.register(ChartTVC.self, forCellReuseIdentifier: ChartTVC.className)
        $0.register(DetailTVC.self, forCellReuseIdentifier: DetailTVC.className)
        $0.register(FilterTVC.self, forCellReuseIdentifier: FilterTVC.className)
        $0.register(StrokeTVC.self, forCellReuseIdentifier: StrokeTVC.className)
        $0.register(DateTVC.self, forCellReuseIdentifier: DateTVC.className)
        $0.register(RoutineTVC.self)
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    let topView = TopView()
    let headerView = HeaderView()
    let statusBar = StatusBar()

    var routineOverViewList: [RoutineOverviewData] = []
    
    // MARK: - func
    
    private func setupMainViewState(to state: CurrentMainViewState, with dateText: String) {
        self.dateText = dateText
        cardView.dateText = dateText
        currentMainViewState = state
        cardView.currentState = currentMainViewState
        strokeState = .none
    }
    
    private func applyStrokeString(with stroke: Stroke) -> String {
        switch stroke {
        case .freestyle:
            return "FREESTYLE"
        case .breaststroke:
            return "BREAST"
        case .backstroke:
            return "BACK"
        case .butterfly:
            return "BUTTERFLY"
        case .none:
            return ""
        }
    }
}

// MARK: - UITableViewDataSource
extension MainTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TotalSection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = TotalSection(rawValue: section) else { return 0 }
        
        switch (sectionType, currentMainViewState) {
        case (.topHeader, _):
            return 0
        case (.content, .routine):
            return routineOverViewList.count
        default:
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMainViewState {
        case .day, .base:
            guard let dayBaseRowType = DayBaseRowType(rawValue: indexPath.row) else { return UITableViewCell() }
            switch dayBaseRowType {
            case .filter:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.className) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.currentMainViewState = self.currentMainViewState
                return cell
            case .date:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.className) as? DateTVC else { return UITableViewCell() }
                cell.setupDateLabel(with: dateText)
                return cell
            case .detail:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.className) as? DetailTVC else { return UITableViewCell() }
                cell.setupTitleLabel(with: currentMainViewState)
                return cell
            case .stroke:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StrokeTVC.className) as? StrokeTVC else { return UITableViewCell() }
                return cell
            case .footer:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .week, .month:
            guard let weekMonthRowType = WeekMonthRowType(rawValue: indexPath.row) else { return UITableViewCell() }
            switch weekMonthRowType {
            case .filter:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.className) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.currentMainViewState = self.currentMainViewState
                cell.stroke = strokeState
                return cell
            case .date:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.className) as? DateTVC else { return UITableViewCell() }
                cell.setupDateLabel(with: dateText)
                return cell
            case .chart:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTVC.className) as? ChartTVC else { return UITableViewCell() }
                cell.playAnimation()
                cell.setupTitleLabel(with: currentMainViewState)
                return cell
            case .detail:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.className) as? DetailTVC else { return UITableViewCell() }
                cell.setupTitleLabel(with: currentMainViewState)
                return cell
            case .footer:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .routine:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVC.className) as? RoutineTVC else { return UITableViewCell()}
            cell.setContentData(overview: routineOverViewList[indexPath.row])
            return cell
        }
    }
}

// MARK: - SelectedRange Delegate
extension MainTableVC: SelectedButtonDelegate {
    func didClickedPeriodFilterButton() {
        setupCardViewState(to: .normal)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedRangeVC") as? SelectedRangeVC
        else { return }
        
        vc.dayData = { [weak self] year, month, day in
            guard let self = self else { return }
            let transYear = year[year.index(year.startIndex, offsetBy: 2)..<year.endIndex]
            let transMonth = (month.count == 1) ? "0\(month)" : month
            let transDay = (day.count == 1) ? "0\(day)" : day
            let date = "\(transYear)/\(transMonth)/\(transDay)"
            let state: CurrentMainViewState = (date == Date().getTimeString()) ? .base : .day
            self.setupMainViewState(to: state, with: date)

            self.selectedDates[0] = "\(year)-\(transMonth)-\(transDay)"
            self.storage.dispatchDayRecord(date: self.selectedDates[0], stroke: "") {
                self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
            }
        }
        vc.weekData = { [weak self] week in
            guard let self = self else { return }
            self.setupMainViewState(to: .week, with: week)
            
            self.selectedDates[0] = "2021-10-18"
            self.selectedDates[1] = "2021-10-24"
            self.storage.dispatchWeekRecord(startDate: self.selectedDates[0],
                                            endDate: self.selectedDates[1],
                                            stroke: "") {
                self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
            }
        }
        vc.monthData = { [weak self] year, month in
            guard let self = self else { return }
            let transMonth = (month.count == 1) ? "0\(month)" : month
            let date = "\(year)/\(transMonth)"
            self.setupMainViewState(to: .month, with: date)
            
            self.selectedDates[0] = "\(year)-\(transMonth)"
            self.storage.dispatchDayRecord(date: self.selectedDates[0], stroke: "") {
                self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
            }
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    func didClickedStrokeFilterButton(with indexPath: Int = 0) {
        setupCardViewState(to: .normal)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }

        vc.strokeData = { [weak self] style in
            guard let self = self else { return }
            self.strokeState = style
            
            switch self.currentMainViewState {
            case .week:
                self.storage.dispatchWeekRecord(startDate: self.selectedDates[0],
                                                endDate: self.selectedDates[1],
                                                stroke: self.applyStrokeString(with: style)) {
                    self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                }
            case .month:
                self.storage.dispatchMonthRecord(date: self.selectedDates[0],
                                                 stroke: self.applyStrokeString(with: style)) {
                    self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                }
            default:
                break
            }
        }
        
        vc.style = strokeState
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
