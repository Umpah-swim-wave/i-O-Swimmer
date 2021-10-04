//
//  DetailView.swift
//  Umpah-iOS
//
//  Created by SHIN YOON AH on 2021/08/17.
//

import UIKit

import Then
import SnapKit

class DetailView: UIView {
    // MARK: - Properties
    let topView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        
        let distanceIconImage = UIImageView().then {
            $0.image = UIImage(named: "ic_swim")
        }
        let distanceTitle = UILabel().then {
            $0.text = "DISTANCE"
            $0.textColor = .upuhSubOrange
            $0.font = .nexaBold(ofSize: 9)
            $0.addCharacterSpacing(kernValue: 2)
        }
        let divideLine = UIView().then {
            $0.backgroundColor = .upuhDivider
            $0.layer.cornerRadius = 3
        }
        let timeIconImage = UIImageView().then {
            $0.image = UIImage(named: "ic_time")
        }
        let timeTitle = UILabel().then {
            $0.text = "TIME"
            $0.textColor = .upuhSubOrange
            $0.font = .nexaBold(ofSize: 9)
            $0.addCharacterSpacing(kernValue: 2)
        }
        
        $0.addSubviews([distanceIconImage, distanceTitle, divideLine,
                        timeIconImage, timeTitle])
        distanceIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(32)
            $0.width.equalTo(20)
            $0.height.equalTo(17.5)
        }
        distanceTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalTo(distanceIconImage.snp.trailing).offset(6)
        }
        divideLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        timeIconImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalTo(divideLine.snp.trailing).offset(30)
            $0.width.height.equalTo(20)
        }
        timeTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalTo(timeIconImage.snp.trailing).offset(6)
        }
    }
    let bottomView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.upuhBlue.withAlphaComponent(0.15).cgColor
        
        let kcalIconImage = UIImageView().then {
            $0.image = UIImage(named: "ic_kcal")
        }
        let heartIconImage = UIImageView().then {
            $0.image = UIImage(named: "ic_heart")
        }
        let divideLine = UIView().then {
            $0.backgroundColor = .upuhDivider
            $0.layer.cornerRadius = 3
        }
        
        $0.addSubviews([kcalIconImage, heartIconImage, divideLine])
        kcalIconImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(32)
            $0.width.equalTo(24)
            $0.height.equalTo(26)
        }
        divideLine.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.top.bottom.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        heartIconImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(divideLine.snp.trailing).offset(22)
            $0.width.equalTo(24)
            $0.height.equalTo(22)
        }
    }
    let warningLabel = UILabel().then {
        $0.text = "휴식시간을 포함한 평균값입니다. 애플 피트니스의 값과 다를 수 있습니다."
        $0.font = .IBMPlexSansRegular(ofSize: 11)
        $0.textColor = .upuhWarning
        
        let image = UIImageView()
        image.image = UIImage(named: "alert-circle")
        $0.addSubview(image)
        $0.tintColor = .upuhGray
        image.snp.makeConstraints {
            $0.width.height.equalTo(14)
            $0.leading.equalToSuperview().inset(-18)
            $0.centerY.equalToSuperview()
        }
    }
    let distanceLabel = UILabel().then {
        $0.text = "5.4km"
        $0.textColor = .upuhBlack
        $0.font = .nexaBold(ofSize: 35)
        $0.changeCharacterAttribute(words: ["km"], size: 22, kernValue: 1)
    }
    let timeLabel = UILabel().then {
        $0.text = "2h 11m"
        $0.textColor = .upuhBlack
        $0.font = .nexaBold(ofSize: 35)
        $0.changeCharacterAttribute(words: ["h", "m"], size: 22, kernValue: -0.1)
    }
    let kcalLabel = UILabel().then {
        $0.text = "390kcal"
        $0.textColor = .upuhBlack
        $0.font = .nexaBold(ofSize: 22)
        $0.changeCharacterAttribute(words: ["kcal"], size: 18, kernValue: 2)
    }
    let bpmLabel = UILabel().then {
        $0.text = "120bpm"
        $0.textColor = .upuhBlack
        $0.font = .nexaBold(ofSize: 22)
        $0.changeCharacterAttribute(words: ["bpm"], size: 18, kernValue: 2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    private func setupLayout() {
        addSubviews([topView, bottomView, warningLabel])
        topView.addSubviews([distanceLabel, timeLabel])
        bottomView.addSubviews([kcalLabel, bpmLabel])
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(110)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(topView)
            $0.height.equalTo(70)
        }
        
        warningLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.top.equalTo(bottomView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(40)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalToSuperview().inset(32)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalTo(topView.snp.centerX).offset(30)
        }
        
        kcalLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.equalToSuperview().inset(64)
        }
        
        bpmLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.leading.equalTo(bottomView.snp.centerX).offset(54)
        }
    }
}
