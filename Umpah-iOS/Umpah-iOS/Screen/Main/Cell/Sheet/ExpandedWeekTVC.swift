//
//  ExpandedWeekTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import SnapKit
import Then

final class ExpandedWeekTVC: UITableViewCell {
    static let identifier = "ExpandedWeekTVC"
    
    // MARK: - properties
    
    private let dayLabel = UILabel().then {
        $0.font = .nexaBold(ofSize: 13)
        $0.textColor = .upuhBadgeOrange
    }
    private let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let timeLabel = UILabel().then {
        $0.text = "00:99:99"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let kcalLabel = UILabel().then {
        $0.text = "320kcal"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
        $0.addCharacterSpacing(kernValue: -1)
    }
    
    // MARK: - init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        render()
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func render() {
        addSubviews([dayLabel, distanceLabel, timeLabel, velocityLabel, kcalLabel])
        
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
    
    private func configUI() {
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func setupDateLabel(with dayTitle: String) {
        dayLabel.text = dayTitle
        dayLabel.addCharacterSpacing(kernValue: 1)
    }
}
