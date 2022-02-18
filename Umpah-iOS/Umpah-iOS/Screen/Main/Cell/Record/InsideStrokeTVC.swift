//
//  InsideStrokeTVC.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/09/12.
//

import UIKit

import SnapKit
import Then

final class InsideStrokeTVC: UITableViewCell {

    // MARK: - properties
    
    private let strokeLabel = UILabel().then {
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.textColor = .upuhBlack
    }
    private let distanceLabel = UILabel().then {
        $0.text = "9999m"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let averageSpeedLabel = UILabel().then {
        $0.text = "1.7m/s"
        $0.font = .IBMPlexSansText(ofSize: 14)
        $0.addCharacterSpacing(kernValue: -1)
    }
    private let bottomLine = UIView().then {
        $0.backgroundColor = .upuhDivider
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
        contentView.addSubviews([strokeLabel, distanceLabel, averageSpeedLabel])
        
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
    
    private func configUI() {
        backgroundColor = .clear
    }
    
    func setupStrokeLabel(to stroke: String, with index: Int) {
        let isLastData = (index == 4)
        if !isLastData {
            contentView.addSubview(bottomLine)
            bottomLine.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0.5)
            }
        }
        
        strokeLabel.text = stroke
    }
}
