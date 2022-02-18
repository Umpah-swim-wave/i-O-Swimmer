//
//  ExpandedStateTableView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/18.
//

import UIKit

class ExpandedStateTableView: BaseView {

    // MARK: - properties
    
    lazy var listTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.showsVerticalScrollIndicator = false
        $0.register(ExpandedDayTVC.self, forCellReuseIdentifier: ExpandedDayTVC.identifier)
        $0.register(ExpandedWeekTVC.self, forCellReuseIdentifier: ExpandedWeekTVC.identifier)
        $0.register(RoutineTVC.self, forCellReuseIdentifier: RoutineTVC.className)
        $0.registerCustomXib(name: RoutineTVC.className)
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    private var dummyStrokes: [String] = ["자유형", "접영", "자유형", "자유형", "자유형", "자유형", "배영", "배영", "평영", "평영", "접영", "자유형", "접영"]
    private let dummyDays: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    private let dummyWeeks: [String] = ["WEEK1", "WEEK2", "WEEK3", "WEEK4", "WEEK5"]
    var upuhRoutineOverViewList: [RoutineOverviewData] = []
    var filteredOverViewList: [RoutineOverviewData] = []
    var rootVC: MainCardVC?
    var currentMainViewState: CurrentMainViewState?
    var isModified = false
}

// MARK: - UITableViewDataSource
extension ExpandedStateTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentMainViewState {
        case .day,
             .base:
            return dummyStrokes.count
        case .week:
            return 7
        case .month:
            return 5
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMainViewState {
        case .day,
             .base:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedDayTVC.identifier) as? ExpandedDayTVC else { return UITableViewCell() }
            cell.delegate = self
            cell.setupLabels(with: dummyStrokes, index: indexPath.row)
            if indexPath.row < dummyStrokes.count - 1 {
                cell.changeCellConfiguration(isModified, dummyStrokes[indexPath.row] == dummyStrokes[indexPath.row + 1])
            } else {
                cell.changeCellConfiguration(isModified, false)
            }
            return cell
        case .week:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedWeekTVC.identifier) as? ExpandedWeekTVC else { return UITableViewCell() }
            cell.setupDateLabel(with: dummyDays[indexPath.row])
            return cell
        case .month:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ExpandedWeekTVC.identifier) as? ExpandedWeekTVC else { return UITableViewCell() }
            cell.setupDateLabel(with: dummyWeeks[indexPath.row])
            return cell
        case .routine:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVC.className) as? RoutineTVC else { return UITableViewCell() }
            cell.setContentData(overview: upuhRoutineOverViewList[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - UITableViewDelegate
extension ExpandedStateTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.separatorStyle = currentMainViewState == .routine ? .none : .singleLine
        return currentMainViewState == .routine ? 168 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch currentMainViewState {
        case .routine:
            return 0
        default:
            return 52
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .white
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        } else {
            switch currentMainViewState {
            case .base,
                 .day:
                cell.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 20)
            case .week:
                cell.separatorInset = .init(top: 0, left: 80, bottom: 0, right: 20)
            case .month:
                cell.separatorInset = .init(top: 0, left: 90, bottom: 0, right: 20)
            default:
                break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch currentMainViewState {
        case .day,
             .base:
            let header = DayHeader()
            return header
        case .week,
             .month:
            let header = WeekMonthHeader()
            header.setupDateTitle(with: currentMainViewState ?? .week)
            return header
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentMainViewState == .routine {
            let storyboard = UIStoryboard(name: "Routine", bundle: nil)
            guard let routineVC = storyboard.instantiateViewController(withIdentifier: RoutineVC.identifier) as? RoutineVC else {return}
            routineVC.modalPresentationStyle = .overFullScreen
            rootVC?.present(routineVC, animated: true, completion: nil)
        }
    }
}

// MARK: - SelectedButtonDelegate
extension ExpandedStateTableView: SelectedButtonDelegate {
    func didClickedStrokeButton(with indexPath: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.sendStrokeStateData = { [weak self] style in
            switch style {
            case .freestyle:
                self?.dummyStrokes[indexPath] = "자유형"
            case .butterfly:
                self?.dummyStrokes[indexPath] = "접영"
            case .backstroke:
                self?.dummyStrokes[indexPath] = "배영"
            case .breaststroke:
                self?.dummyStrokes[indexPath] = "평영"
            default:
                break
            }
            self?.listTableView.reloadSections(IndexSet(0...0), with: .fade)
        }
        rootVC?.present(vc, animated: true, completion: nil)
    }
    
    func didClickedMergeButton(with indexPath: Int) {
        dummyStrokes.remove(at: indexPath)
        listTableView.reloadSections(IndexSet(0...0), with: .fade)
    }
}
