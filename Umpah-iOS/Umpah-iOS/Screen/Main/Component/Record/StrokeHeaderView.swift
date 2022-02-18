//
//  StrokeHeaderView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2022/02/12.
//

import UIKit

import SnapKit
import Then

final class StrokeHeaderView: UIView {

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
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
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
    
    // MARK: - func
    
    private func render() {
        addSubviews([strokeLabel, distanceLabel, speedLabel])
    }
}
