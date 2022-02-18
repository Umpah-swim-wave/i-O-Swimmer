//
//  StrokeHeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/12.
//

import UIKit

import SnapKit
import Then

final class StrokeHeaderView: BaseView {

    // MARK: - properties
    
    private let strokeLabel = UILabel().then {
        $0.text = "영법"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    private let distanceLabel = UILabel().then {
        $0.text = "거리"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    private let speedLabel = UILabel().then {
        $0.text = "평균속도"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    
    override func render() {
        addSubviews([strokeLabel, distanceLabel, speedLabel])
        
        strokeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(135)
        }
        speedLabel.snp.makeConstraints {
            $0.top.equalTo(strokeLabel)
            $0.trailing.equalToSuperview().inset(43)
        }
    }
}
