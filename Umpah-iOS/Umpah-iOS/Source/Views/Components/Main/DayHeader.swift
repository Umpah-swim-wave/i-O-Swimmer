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
        $0.font = .systemFont(ofSize: 12)
    }
    let distanceTitle = UILabel().then {
        $0.text = "거리"
        $0.font = .systemFont(ofSize: 12)
    }
    let velocityTitle = UILabel().then {
        $0.text = "속도"
        $0.font = .systemFont(ofSize: 12)
    }
    let timeTitle = UILabel().then {
        $0.text = "시간"
        $0.font = .systemFont(ofSize: 12)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        distanceTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(34)
        }
        
        velocityTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(distanceTitle.snp.leading).offset(-40)
        }
        
        timeTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(velocityTitle.snp.leading).offset(-40)
        }
    }
}
