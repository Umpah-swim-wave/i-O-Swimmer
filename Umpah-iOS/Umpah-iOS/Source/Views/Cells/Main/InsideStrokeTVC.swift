//
//  InsideStrokeTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/12.
//

import UIKit

import Then
import SnapKit

class InsideStrokeTVC: UITableViewCell {
    static let identifier = "InsideStrokeTVC"

    // MARK: - Properties
    var strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    var distanceLabel = UILabel().then {
        $0.text = "9999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.addCharacterSpacing(kernValue: -1)
    }
    var averageSpeedLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.addCharacterSpacing(kernValue: -1)
    }
    var bottomLine = UIView().then {
        $0.backgroundColor = .upuhDivider
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubviews([strokeLabel,
                     distanceLabel,
                     averageSpeedLabel,
                     bottomLine])
        
        strokeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(24)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(130)
        }
        
        averageSpeedLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(43)
        }
    }
    
    func setupLabelData(stroke: String, index: Int) {
        strokeLabel.text = stroke
        
        if index != 4 {
            bottomLine.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        }
    }
}
