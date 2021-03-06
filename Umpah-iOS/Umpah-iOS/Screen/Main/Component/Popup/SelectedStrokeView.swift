//
//  SelectedStrokeView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/28.
//

import UIKit

import SnapKit
import Then

final class SelectedStrokeView: BaseView {
    
    private enum Size {
        static let cellHeight: CGFloat = 40
    }
    
    // MARK: - properties
    
    private lazy var strokeTableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.isScrollEnabled = false
        $0.register(SelectedStrokeTVC.self, forCellReuseIdentifier: SelectedStrokeTVC.className)
    }
    private let titleLabel = UILabel().then {
        $0.text = "영법 선택"
        $0.textColor = .upuhBlack
        $0.font = .IBMPlexSansSemiBold(ofSize: 18)
    }
    private let strokes: [String] = ["자유형", "평영", "배영", "접영"]
    private var currentSelection = -1
    var style: Stroke = .none
    weak var rootVC: SelectedStrokeVC?
    
    override func render() {
        addSubviews([titleLabel, strokeTableView])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        strokeTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(34)
        }
    }
}

// MARK: - UITableViewDataSource
extension SelectedStrokeView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strokes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectedStrokeTVC.className) as? SelectedStrokeTVC else { return UITableViewCell() }
        cell.strokeLabel.text = strokes[indexPath.row]
        switch style {
        case .freestyle:
            currentSelection = 0
        case .breaststroke:
            currentSelection = 1
        case .backstroke:
            currentSelection = 2
        case .butterfly:
            currentSelection = 3
        case .none:
            break
        }
        
        if indexPath.row == currentSelection {
            cell.isSelected = true
        }
        
        return cell
    }
}

extension SelectedStrokeView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Size.cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0,
                                                left: (UIScreen.main.bounds.size.width - 32) / 2,
                                                bottom: 0,
                                                right: (UIScreen.main.bounds.size.width - 32) / 2)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let deselectedIndexPath = IndexPath(row: currentSelection, section: 0)
        if let deselectedCell = tableView.cellForRow(at: deselectedIndexPath) as? SelectedStrokeTVC {
            deselectedCell.isSelected = false
        }
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectedStrokeTVC else { return }
        cell.isSelected = true
        switch indexPath.row {
        case 0:
            style = .freestyle
        case 1:
            style = .breaststroke
        case 2:
            style = .backstroke
        case 3:
            style = .butterfly
        default:
            style = .none
        }
        
        rootVC?.sendStrokeStateData?(style)
        rootVC?.dismiss(animated: true, completion: nil)
    }
}
