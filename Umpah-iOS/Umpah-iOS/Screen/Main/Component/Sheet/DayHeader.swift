//
//  DayHeader.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import Then
import SnapKit

class DayHeader: UIView {
    // MARK: - Properties
    let strokeTitle = UILabel().then {
        $0.text = "영법"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    let distanceTitle = UILabel().then {
        $0.text = "거리"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    let velocityTitle = UILabel().then {
        $0.text = "속도"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }
    let timeTitle = UILabel().then {
        $0.text = "시간"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        addSubviews([strokeTitle,
                     distanceTitle,
                     velocityTitle,
                     timeTitle])
        
        strokeTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(50)
        }
        
        timeTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(58)
        }
        
        velocityTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(timeTitle.snp.leading).offset(-30)
        }
        
        distanceTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(velocityTitle.snp.leading).offset(-31)
        }
    }
}