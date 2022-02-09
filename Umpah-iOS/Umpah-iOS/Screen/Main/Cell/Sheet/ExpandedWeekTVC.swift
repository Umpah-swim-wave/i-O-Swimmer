//
//  ExpandedWeekTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class ExpandedWeekTVC: UITableViewCell {
    static let identifier = "ExpandedWeekTVC"
    
    // MARK: - Properties
    let dayLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 13)
        $0.textColor = .upuhBadgeOrange
    }
    let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let timeLabel = UILabel().then {
        $0.text = "00:99:99"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    let kcalLabel = UILabel().then {
        $0.text = "320kcal"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubviews([dayLabel,
                     distanceLabel,
                     timeLabel,
                     velocityLabel,
                     kcalLabel])
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(242)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(169)
        }
        
        velocityLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(107)
        }
        
        kcalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }

}
