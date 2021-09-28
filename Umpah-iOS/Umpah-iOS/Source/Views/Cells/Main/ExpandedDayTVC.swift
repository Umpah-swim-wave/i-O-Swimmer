//
//  ExpandedDayTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class ExpandedDayTVC: UITableViewCell {
    static let identifier = "ExpandedDayTVC"
    
    // MARK: - Properties
    let rowLabel = UILabel().then {
        $0.text = "01"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textColor = .orange
    }
    let strokeLabel = UILabel().then {
        $0.text = "자유형"
        $0.font = .systemFont(ofSize: 14)
    }
    let distanceLabel = UILabel().then {
        $0.text = "999m"
        $0.font = .systemFont(ofSize: 14)
    }
    let velocityLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .systemFont(ofSize: 14)
    }
    let timeLabel = UILabel().then {
        $0.text = "99:99"
        $0.font = .systemFont(ofSize: 14)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubviews([rowLabel,
                     strokeLabel,
                     distanceLabel,
                     velocityLabel,
                     timeLabel])
        
        rowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(20)
        }
        
        strokeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(46)
            $0.centerY.equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(146)
            $0.centerY.equalToSuperview()
        }
        
        velocityLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(81)
            $0.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }

}
