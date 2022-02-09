//
//  MainTableVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/09.
//

import UIKit

class MainTableVC: MainCardVC {
    
    // MARK: - properties
    
    lazy var baseTableView = UITableView().then {
        $0.dataSource = self
        $0.register(ChartTVC.self, forCellReuseIdentifier: ChartTVC.identifier)
        $0.register(DetailTVC.self, forCellReuseIdentifier: DetailTVC.identifier)
        $0.register(FilterTVC.self, forCellReuseIdentifier: FilterTVC.identifier)
        $0.register(StrokeTVC.self, forCellReuseIdentifier: StrokeTVC.identifier)
        $0.register(DateTVC.self, forCellReuseIdentifier: DateTVC.identifier)
        $0.register(RoutineTVC.self)
        $0.backgroundColor = .clear
        $0.estimatedRowHeight = 100
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        
        if #available(iOS 15.0, *) {
            $0.sectionHeaderTopPadding = 0
        }
    }
    let topView = TopView()
    let headerView = HeaderView()
    let statusBar = StatusBar()

    var routineOverViewList: [RoutineOverviewData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension MainTableVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            if currentMainViewState != .routine {
                return 5
            } else {
                return routineOverViewList.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentMainViewState {
        case .day,
             .base:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.identifier) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.state = currentMainViewState
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.identifier) as? DateTVC else { return UITableViewCell() }
                cell.dateLabel.text = dateText
                cell.dateLabel.addCharacterSpacing(kernValue: 2)
                cell.dateLabel.font = .nexaBold(ofSize: 16)
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
                cell.titleLabel.text = "OVERVIEW"
                cell.titleLabel.addCharacterSpacing(kernValue: 2)
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: StrokeTVC.identifier) as? StrokeTVC else { return UITableViewCell() }
                cell.titleLabel.text = "TOTAL"
                cell.titleLabel.addCharacterSpacing(kernValue: 2)
                return cell
            default:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .week,
             .month:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterTVC.identifier) as? FilterTVC else { return UITableViewCell() }
                cell.delegate = self
                cell.state = currentMainViewState
                cell.stroke = strokeState
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DateTVC.identifier) as? DateTVC else { return UITableViewCell() }
                cell.dateLabel.text = dateText
                cell.dateLabel.addCharacterSpacing(kernValue: 2)
                if dateText == "이번주" || dateText == "지난주" {
                    cell.dateLabel.font = .IBMPlexSansSemiBold(ofSize: 16)
                } else {
                    cell.dateLabel.font = .nexaBold(ofSize: 16)
                }
                return cell
            case 2:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartTVC.identifier) as? ChartTVC else { return UITableViewCell() }
                cell.combineChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .linear)
                
                if currentMainViewState == .week {
                    cell.titleLabel.text = "WEEKLY RECORD"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                } else {
                    cell.titleLabel.text = "MONTHLY RECORD"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                }
                return cell
            case 3:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailTVC.identifier) as? DetailTVC else { return UITableViewCell() }
                
                if currentMainViewState == .week {
                    cell.titleLabel.text = "WEEKLY OVERVIEW"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                } else {
                    cell.titleLabel.text = "MONTHLY OVERVIEW"
                    cell.titleLabel.addCharacterSpacing(kernValue: 2)
                }
                
                return cell
            default:
                let cell = UITableViewCell(frame: .zero)
                cell.backgroundColor = .upuhBackground
                cell.selectionStyle = .none
                return cell
            }
        case .routine:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTVC.identifier) as? RoutineTVC else { return UITableViewCell()}
            cell.setContentData(overview: routineOverViewList[indexPath.row])
            return cell
        }
    }
}

// MARK: - SelectedRange Delegate
extension MainTableVC: SelectedRangeDelegate {
    func didClickedRangeButton() {
        cardView.cardViewState = .normal
        applyCardViewTopConstraint(with: .normal)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedRangeVC") as? SelectedRangeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.dayData = { year, month, day in
            print("dayData : \(year) \(month) \(day)")
            let transYear = year[year.index(year.startIndex, offsetBy: 2)..<year.endIndex]
            let transMonth = (month.count == 1) ? "0\(month)" : month
            let transDay = (day.count == 1) ? "0\(day)" : day
            self.dateText = "\(transYear)/\(transMonth)/\(transDay)"
            self.cardView.dateText = self.dateText
            self.currentMainViewState = (self.dateText == self.dateformatterForScreen.string(from: Date())) ? .base : .day
            self.strokeState = .none
            
            // fetch day response
            self.selectedDates[0] = "\(year)-\(transMonth)-\(transDay)"
            self.storage.dispatchDayRecord(date: self.selectedDates[0], stroke: "") {
                print("day Record")
                
                self.baseTableView.reloadSections(IndexSet(1...1), with: .fade)
                self.cardView.currentState = self.currentMainViewState
            }
        }
        vc.weekData = { week in
            print("weekData : \(week)")
            self.dateText = week
            self.cardView.dateText = self.dateText
            self.currentMainViewState = .week
            self.strokeState = .none
            
            // fetch week response
            self.selectedDates[0] = "2021-10-18"
            self.selectedDates[1] = "2021-10-24"
            
            self.storage.dispatchWeekRecord(startDate: self.selectedDates[0],
                                            endDate: self.selectedDates[1],
                                            stroke: "") {
                print("Week Record")
                
                self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                self.cardView.currentState = self.currentMainViewState
            }
        }
        vc.monthData = { year, month in
            print("monthData : \(year) \(month)")
            let transMonth = (month.count == 1) ? "0\(month)" : month
            self.dateText = "\(year)/\(transMonth)"
            self.cardView.dateText = self.dateText
            self.currentMainViewState = .month
            self.strokeState = .none
            
            // fetch month response
            self.selectedDates[0] = "\(year)-\(transMonth)"
            self.storage.dispatchDayRecord(date: self.selectedDates[0], stroke: "") {
                print("month Record")
                
                self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                self.cardView.currentState = self.currentMainViewState
            }
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    func didClickedStrokeButton(indexPath: Int = 0) {
        cardView.cardViewState = .normal
        applyCardViewTopConstraint(with: .normal)
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.style = self.strokeState
        vc.strokeData = { style in
            print(style)
            self.strokeState = style
            
            switch self.currentMainViewState {
            case .week:
                self.storage.dispatchWeekRecord(startDate: self.selectedDates[0],
                                                endDate: self.selectedDates[1],
                                                stroke: style.rawValue) {
                    print("Week Record with stroke")
                    
                    self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                }
            case .month:
                self.storage.dispatchMonthRecord(date: self.selectedDates[0],
                                                 stroke: style.rawValue) {
                    print("Month Record with stroke")
                    
                    self.baseTableView.reloadSections(IndexSet(1...1), with: .automatic)
                }
            default:
                break
            }
        }
        
        present(vc, animated: true, completion: nil)
    }
}
