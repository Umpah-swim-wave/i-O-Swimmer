//
//  WeekMonthHeader.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/31.
//

import UIKit

import SnapKit
import Then

final class WeekMonthHeader: BaseView {
    
    // MARK: - properties
    
    private let dateTitle = UILabel().then {
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
    private let kcalTitle = UILabel().then {
        $0.text = "칼로리"
        $0.font = .IBMPlexSansRegular(ofSize: 12)
        $0.textColor = .upuhHeaderGray
    }

    override func render() {
        addSubviews([dateTitle, distanceTitle, timeTitle, velocityTitle, kcalTitle])
        
        dateTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(34)
        }
        distanceTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(timeTitle.snp.leading).offset(-44)
        }
        timeTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(velocityTitle.snp.leading).offset(-44)
        }
        velocityTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalTo(kcalTitle.snp.leading).offset(-44)
        }
        kcalTitle.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(40)
        }
    }
    
    override func configUI() {
        backgroundColor = .white
    }
    
    func setupDateTitle(with state: CurrentMainViewState) {
        switch state {
        case .week:
            dateTitle.text = "요일"
        case .month:
            dateTitle.text = "주차"
        default:
            break
        }
    }
}
