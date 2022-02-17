//
//  DayHeader.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import SnapKit
import Then

final class DayHeader: BaseView {
    
    // MARK: - properties
    
    private let strokeTitle = UILabel().then {
        $0.text = "영법"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    private let distanceTitle = UILabel().then {
        $0.text = "거리"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    private let velocityTitle = UILabel().then {
        $0.text = "속도"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    private let timeTitle = UILabel().then {
        $0.text = "시간"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }

    override func render() {
        addSubviews([strokeTitle, distanceTitle, velocityTitle, timeTitle])
        
        strokeTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(50)
        }
        timeTitle.snp.makeConstraints {
            $0.top.bottom.equalTo(strokeTitle)
            $0.trailing.equalToSuperview().inset(58)
        }
        velocityTitle.snp.makeConstraints {
            $0.top.bottom.equalTo(strokeTitle)
            $0.trailing.equalTo(timeTitle.snp.leading).offset(-30)
        }
        distanceTitle.snp.makeConstraints {
            $0.top.bottom.equalTo(strokeTitle)
            $0.trailing.equalTo(velocityTitle.snp.leading).offset(-31)
        }
    }
    
    override func configUI() {
        backgroundColor = .white
    }
}
