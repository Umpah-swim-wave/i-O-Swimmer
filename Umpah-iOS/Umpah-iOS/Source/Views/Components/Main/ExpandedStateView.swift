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
    
    var strokes: [String] = ["자유형", "접영", "자유형", "자유형", "자유형", "자유형", "배영", "배영", "평영", "평영", "접영", "자유형", "접영"]
    let days: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    let weeks: [String] = ["WEEK1", "WEEK2", "WEEK3", "WEEK4", "WEEK5"]
        
    var state: CurrentState?
    private var isModified = false
    private var root: UIViewController?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupModifyButton()
    }
    
    convenience init(root: UIViewController) {
        self.init(frame: .zero)
        self.root = root
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
            cell.strokeLabel.text = strokes[indexPath.row]
            if indexPath.row >= 9 {
                cell.rowLabel.text = "\(indexPath.row + 1)"
            } else {
                cell.rowLabel.text = "0\(indexPath.row + 1)"
            }
            
            if #available(iOS 15, *) {
                var configuration = UIButton.Configuration.plain()
                configuration.image = UIImage(systemName: "chevron.down")
                configuration.titlePadding = 0
                configuration.imagePadding = 2
                configuration.baseForegroundColor = .black
                configuration.attributedTitle = AttributedString(strokes[indexPath.row], attributes: AttributeContainer([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
                configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                cell.strokeButton.configuration = configuration
            } else {
                cell.strokeButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                cell.strokeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
                cell.strokeButton.setTitle(strokes[indexPath.row], for: .normal)
                cell.strokeButton.titleLabel?.font = .systemFont(ofSize: 14)
                cell.strokeButton.setTitleColor(.black, for: .normal)
                cell.strokeButton.sizeToFit()
            }
            
            cell.delegate = self
            
            if indexPath.row < strokes.count - 1 {
                cell.changeCellConfiguration(isModified, strokes[indexPath.row] == strokes[indexPath.row + 1])
            }
            
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

// MARK: - SelectedRangeDelegate
extension ExpandedStateView: SelectedRangeDelegate {
    func didClickedStrokeButton(indexPath: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectedStrokeVC") as? SelectedStrokeVC else { return }
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.strokeData = { style in
            let indexPathRow = IndexPath(row: indexPath, section: 0)

            switch style {
            case .freestyle:
                self.strokes[indexPath] = "자유형"
            case .butterfly:
                self.strokes[indexPath] = "접영"
            case .backstroke:
                self.strokes[indexPath] = "배영"
            case .breaststroke:
                self.strokes[indexPath] = "평영"
            default:
                break
            }
            
            self.listTableView.reloadRows(at: [indexPathRow], with: .fade)
        }
        
        root?.present(vc, animated: true, completion: nil)
    }
}
